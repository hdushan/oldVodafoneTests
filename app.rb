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
  tracking_id = (params[:tracking_id] || "").gsub(/\s+/, "")

  if(!tracking_id.empty?)
    status_details = FulfilmentServiceProviderClient.new.get_order_status(tracking_id)
    haml :trace_without_styling,
      :locals => { :details => status_details }
  else
    "you must provide tracking number"
  end
end

get '/trace' do
  haml :trace
end