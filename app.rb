require 'sinatra'
require "sinatra/namespace"
require 'haml'

require_relative 'sinatra_assets'
require_relative 'lib/fulfilment_service_provider_client'
require_relative 'lib/app_helper'

set :public_folder, 'public'

get '/tnt' do
  haml :track_form
end

post '/track' do
  @order_id = params[:tracking_id].strip
  status_details = FulfilmentServiceProviderClient.new.get_order_status(@order_id)

  if(status_details.key? 'error')
    @error = error_message[status_details['error']]
    haml :track_form
  else
    @auth_url = generate_auth_url status_details, @order_id
    haml :order_status, :locals => { :details => status_details }
  end
end

get '/auth' do
  @order_id = params[:order_id]
  redirect '/tnt' if @order_id.nil? || !['email', 'dob'].include?(params[:authType])

  @auth_email = params[:authType] == 'email'
  @auth_birthday = params[:authType] == 'dob'

  haml :auth_form
end

# TODO: temparary route to see the styled order status page
get '/trace' do
  haml :trace_styled_standalone
end
