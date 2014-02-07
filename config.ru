$: << './lib'

require 'dotenv'
path = ".env.#{ENV['RAILS_ENV']}"
Dotenv.load(path, '.env')

require 'rack-timeout'
use Rack::Timeout
Rack::Timeout.timeout = (ENV['RACK_TIMEOUT'] || 65).to_i

require 'sinatra'

require File.expand_path '../app.rb', __FILE__
run App.new
