require 'sinatra'
require "sinatra/namespace"
require 'haml'

require_relative 'sinatra_assets'
require_relative 'lib/fulfilment_service_provider_client'
require_relative 'lib/app_helper'

set :public_folder, 'public'

get '/tnt' do
  haml :main
end

post '/track' do
  @order_id = params[:tracking_id].strip
  status_details = FulfilmentServiceProviderClient.new.get_order_status(@order_id)

  if(status_details.key? 'error')
    @error = error_message[status_details['error']]
    haml :main
  else
    haml :trace_without_styling, :locals => { :details => status_details }
  end
end

get '/auth' do
  @order_id = params[:orderID]
  redirect '/tnt' if @order_id.nil?

  @auth_email = true if params[:authType] == 'email'
  @auth_birthday = true if params[:authType] == 'bday'

  haml :auth
end

get '/trace' do
  haml :trace
end