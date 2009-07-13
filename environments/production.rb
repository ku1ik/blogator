puts "Configuring production environment..."
require 'rack/cache'
use Rack::Cache, :verbose => true

#log_dir = File.join(APP_ROOT, 'log')
#FileUtils.mkdir_p(log_dir) unless File.exists?(log_dir)
#log = File.new(File.join(log_dir, "sinatra.log"), "a")
#STDOUT.reopen(log)
#STDERR.reopen(log)
