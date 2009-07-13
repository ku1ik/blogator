require 'rack/cache'

require File.join(File.dirname(__FILE__), 'app.rb')

#log_dir = File.join(APP_ROOT, 'log')
#FileUtils.mkdir_p(log_dir) unless File.exists?(log_dir)
#log = File.new(File.join(log_dir, "sinatra.log"), "a")
#STDOUT.reopen(log)
#STDERR.reopen(log)

use Rack::Cache, :verbose => true

run BlogApp
