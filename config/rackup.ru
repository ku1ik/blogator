require File.join(File.dirname(__FILE__), '..', 'app.rb')

set :run, false

log_dir = File.join(File.dirname(__FILE__), '..', 'log')
FileUtils.mkdir_p log_dir unless File.exists?(log_dir)
log = File.new(File.join(log_dir, "sinatra.log"), "a")
STDOUT.reopen(log)
STDERR.reopen(log)

run BlogApp
#run Sinatra::Application
