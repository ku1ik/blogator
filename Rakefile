begin
  require "vlad"
  Vlad.load(:app => "passenger", :web => nil, :scm => "git")
rescue LoadError
  # do nothing
end

task :env do
  require 'init'
end

namespace :db do
  desc "Autoupgrade db"
  task :autoupgrade  => :env do
    DataMapper.auto_upgrade!
  end
end
