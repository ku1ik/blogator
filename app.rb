require File.join(File.dirname(__FILE__), 'init.rb')
require 'sinatra/base'
require 'sinatras-hat'

class BlogApp < Sinatra::Base
  set :run, false
  set :app_file, __FILE__
  set :logging, true
  set :static, true
  set :root, APP_ROOT
  set :dump_errors, true

  configure do
  end

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
    puts options.environment
#    puts production?
  end

  get /^\/blog\/\d{4}\/\d{2}\/\d{2}\/([^\.]+)(\.\w+)?/ do
    @post = Post.first(:slug => params[:captures].first) or raise Sinatra::NotFound
    @title = @post.title
    @keywords = @post.tag_list.split(", ")
    erb :"posts/show"
  end

  get /^\/(blog\/?)?$/ do
    @posts = Post.all(:order => [:created_at.desc])
    erb :home
  end

  get '/blog/tag/:tag' do
    tag = Tag.first(:name => params[:tag])
    if tag
      @title = "Posts tagged with '#{tag.name}':"
      @keywords = [tag.name]
      @posts = tag.posts
      erb :"posts/list"
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
      erb :"posts/list"
    end
  end

  get '/:static_page' do
    page = params[:static_page]
    begin
      @content = render_static_page(File.read(APP_ROOT + "/content/" + page + ".txt"))
      @title = { "contact" => "Contact", "about-me" => "About Me", "projects" => "My projects" }[page]
      erb :static
    rescue Errno::ENOENT
      pass
    end
  end

  get '/projects/:project' do
    project = params[:project]
    begin
      @content = render_static_page(File.read(APP_ROOT + "/content/projects/" + project + ".txt"))
      @title = { "off" => "Open File Fast", "dece" => "DeCe", "rainbow" => "Rainbow" }[project]
      @keywords = [project]
      erb :static
    rescue Errno::ENOENT
      pass
    end
  end

  get '/atom/feed' do
    @posts = Post.all(:order => [:created_at.desc], :limit => 10)
    last_modified(@posts.first.try(:created_at)) # Conditinal GET, send 304 if not modified
    builder :atom
  end

end

BlogApp.run! if __FILE__ == $0
