$: << './lib'

require 'dotenv'
path = ".env.#{ENV['RAILS_ENV']}"
Dotenv.load(path, '.env')

require 'rack-timeout'
use Rack::Timeout
Rack::Timeout.timeout = (ENV['RACK_TIMEOUT'] || 65).to_i
Rack::Timeout.logger.level = ::Logger.const_get(ENV['RACK_TIMEOUT_LOG_LEVEL']||'WARN')

require 'sinatra'
require File.expand_path '../app.rb', __FILE__
require 'newrelic_rpm'
run App.new
