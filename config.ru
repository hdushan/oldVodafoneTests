require 'dotenv'

path = ".env" + ( ["development"].include?(ENV['RACK_ENV']) ? "" : ".#{ENV['RACK_ENV']}")
Dotenv.load(path) if File.exists?(path)

require 'sinatra'
require File.expand_path '../app.rb', __FILE__

run Sinatra::Application
