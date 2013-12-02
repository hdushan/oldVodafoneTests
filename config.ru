require 'sinatra'

require 'dotenv'
path = ".env.#{ENV['RAILS_ENV']}"
Dotenv.load(path, '.env')

require File.expand_path '../app.rb', __FILE__
run Sinatra::Application
