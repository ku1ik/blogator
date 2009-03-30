require File.join(File.dirname(__FILE__), 'app.rb')

set :run, false
set :environment, :production

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

run BlogApp
#run Sinatra::Application
