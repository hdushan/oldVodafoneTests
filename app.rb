require 'sinatra'
require "sinatra/namespace"

require 'haml'
#require 'newrelic_rpm'
require_relative 'sinatra_assets'

get '/tnt' do
  haml :main
end