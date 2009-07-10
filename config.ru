APP_ROOT = File.dirname(__FILE__)

require File.join(APP_ROOT, 'app.rb')

#log_dir = File.join(APP_ROOT, 'log')
#FileUtils.mkdir_p(log_dir) unless File.exists?(log_dir)
#log = File.new(File.join(log_dir, "sinatra.log"), "a")
#STDOUT.reopen(log)
#STDERR.reopen(log)

run BlogApp
