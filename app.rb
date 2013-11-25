require 'sinatra'
require "sinatra/namespace"
require 'haml'
require_relative 'sinatra_assets'
require_relative 'lib/fulfilment_service_provider_client'

set :public_folder, 'public'

get '/tnt' do
  haml :main
end

post '/track' do
  FulfilmentServiceProviderClient.new.get_order_status(params[:tracking_id])
end

get '/trace' do
  haml :trace
end

get '/trace.css' do
  sass :trace
end