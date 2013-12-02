require 'sinatra'
require File.expand_path '../app.rb', __FILE__

require 'dotenv'
path = ".env.#{ENV['RAILS_ENV']}"
Dotenv.load(path, '.env')

run Sinatra::Application
