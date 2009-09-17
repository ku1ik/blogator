puts "Configuring production environment..."
require 'rack/cache'
use Rack::Cache, :verbose => true

# configure logging
log_dir = File.join(APP_ROOT, 'log')
FileUtils.mkdir_p(log_dir) unless File.exists?(log_dir)
log = File.new(File.join(log_dir, "sinatra.log"), "a")
$stdout.reopen(log)
$stderr.reopen(log) 
