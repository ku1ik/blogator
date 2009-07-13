require 'rubygems'
require 'dm-core'
require 'dm-aggregates'
require 'dm-timestamps'
require 'dm-types'
require 'dm-validations'
require 'redcloth'

APP_ROOT = File.dirname(__FILE__)
DataMapper.setup(:default, "sqlite3://#{File.expand_path(File.join(File.dirname(__FILE__), 'db.sqlite3'))}")
require File.join(APP_ROOT, 'local_config.rb')
%w(extensions.rb helpers.rb renderers.rb models.rb).each { |f| require File.join(APP_ROOT, 'lib', f) }
