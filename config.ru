require 'dotenv'
Dotenv.load # read default settings from .env

ENV['RACK_ENV'] = ENV['RAILS_ENV']
path = ".env.#{ENV['RACK_ENV']}"
Dotenv.load(path) if File.exists?(path) # override standard .env

require 'sinatra'
require File.expand_path '../app.rb', __FILE__

run Sinatra::Application
