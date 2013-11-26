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
  tracking_id = params[:tracking_id]
  if(!tracking_id.nil?)
    FulfilmentServiceProviderClient.new.get_order_status(tracking_id)
  else
    "you must provide tracking number"
  end
end

get '/trace' do
  haml :trace
end

get '/trace.css' do
  sass :trace
end