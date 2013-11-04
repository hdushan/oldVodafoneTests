require 'sinatra'
require "sinatra/namespace"

require 'haml'
#require 'newrelic_rpm'
require_relative 'sinatra_assets'

get '/' do
  haml :main
end