require 'dotenv'
Dotenv.load

require 'sinatra'
require File.expand_path '../app.rb', __FILE__

run Sinatra::Application
