require File.join(File.dirname(__FILE__), 'init.rb')
require 'sinatra'
require 'sinatras-hat'

class BlogApp < Sinatra::Base
#  configure do
    set :run, false
    set :app_file, __FILE__
    set :logging, true
    set :static, true
    set :root, APP_ROOT
    set :dump_errors, true
#  end

  helpers do
    include Sickill::Helpers
  end

  not_found do
    erb :"404"
  end

  error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].name
  end

  mount Post do
    finder { |model, params| model.all(:order => [:created_at.desc]) }
    record { |model, params| model.first(:id => params[:id]) }
    protect :all, :username => "kill", :password => "karnuf", :realm => "BLOGZ"
    after :create do |on|
      on.success { |record| redirect(record.url) }
    end
    after :update do |on|
      on.success { |record| redirect(record.url) }
    end
  end

  before do
    @tags = Tag.all(:posts_count.gte => 1, :order => [:name])
    @archives = Post.all.to_a.group_by { |p| Date.new(p.created_at.year, p.created_at.month) }.map { |date, posts| posts.size }
  end

  get '/' do
    @posts = Post.all(:order => [:created_at.desc])
    erb :home
  end

  get /blog\/\d{4}\/\d{2}\/\d{2}\/([^\.]+)(\.\w+)?/ do
    @post = Post.first(:slug => params[:captures].first) or raise Sinatra::NotFound
    @title = @post.title
    erb :post
  end

  get /\/(contact|about-me|projects)(\.\w+)?$/ do
    page = params[:captures].first
    @title = { "contact" => "Contact", "about-me" => "About Me" }[page]
    @content = RedCloth.new(File.read(APP_ROOT + "/content/" + page + ".txt")).to_html
    erb :static
  end

  get '/blog/tag/:tag' do
    tag = Tag.first(:name => params[:tag])
    if tag
      @title = "Posts tagged with '#{tag.name}':"
      @posts = tag.posts
      erb :posts
    else
      redirect "/"
    end
  end

  ['/blog/:year/?', '/blog/:year/:month/?'].each do |path|
    get path do
      year = params[:year].to_i
      params[:month] ? (start_month = end_month = params[:month].to_i) : (start_month, end_month = 1, 12)
      @title = "Archive for #{year}"
      @title << "/#{start_month.to_s.rjust(2, "0")}" if start_month == end_month
      @title << ":"
      @posts = Post.all(:created_at => (DateTime.new(year, start_month)..DateTime.new(year, end_month, -1)), :order => [:created_at.desc])
      erb :posts
    end
  end
end

#BlogApp.run!(:port => 6100, :server => "thin", :environment => :production) if __FILE__ == $0
