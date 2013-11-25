require 'sinatra'
require "sinatra/namespace"

require 'haml'
#require 'newrelic_rpm'
require_relative 'sinatra_assets'
require_relative 'lib/fulfilment_service_provider_client'

get '/tnt' do
  haml :main
end

post '/track' do
  FulfilmentServiceProviderClient.new.get_order_status(params[:tracking_id])
end