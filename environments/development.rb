puts "Configuring development environment..."
require 'rack-lesscss'
use Rack::LessCss, :less_path => File.join(APP_ROOT, "public", "css"), :css_route => "/css"
