require 'rubygems'
require 'dm-core'
require 'dm-aggregates'
require 'dm-timestamps'
require 'dm-types'
require 'dm-validations'
require 'redcloth'

APP_ROOT = File.dirname(__FILE__)

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db.sqlite3")
#DataObjects::Sqlite3.logger = DataObjects::Logger.new(STDOUT, 0)

require File.join(File.dirname(__FILE__), 'lib', 'extensions.rb')
require File.join(File.dirname(__FILE__), 'lib', 'helpers.rb')
require File.join(File.dirname(__FILE__), 'lib', 'renderers.rb')
require File.join(File.dirname(__FILE__), 'lib', 'models.rb')