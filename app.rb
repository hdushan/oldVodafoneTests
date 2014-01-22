require 'sinatra'
require "sinatra/namespace"
require 'haml'
require 'user_agent'

require_relative 'sinatra_assets'
require_relative 'lib/fulfilment_service_provider_client'
require_relative 'lib/auspost/auspost_response'
require_relative 'lib/aus_post_client'
require_relative 'lib/app_helper'
require_relative 'lib/mega_menu/mega_menu_api_client'

class App < Sinatra::Base
  include Assets
  enable :logging

  def initialize(mega_menu_client=nil, fulfilment_client=nil)
    super()
    @fulfilment_client = fulfilment_client || FulfilmentServiceProviderClient.new
    @mega_menu_client = mega_menu_client || MegaMenuAPIClient.new
  end

  def mega_menu
    logger.info('Getting the Mega Menu')
    @is_mobile_user = UserAgent.parse(request.user_agent).mobile?
    @mega_menu = @mega_menu_client.get_menu(@is_mobile_user)
    logger.info("MegaMenu fetched for #{ @is_mobile_user ? 'mobile' : 'desktop' }")
  end

  get '/tnt' do
    mega_menu

    haml :track_form
  end

  get '/tnt/:id' do
    mega_menu
    
    @error = 'Order not found'
    halt 404, haml(:error)
  end

  post '/track' do
    mega_menu

    @order_id = params[:tracking_id].strip
    status_details = @fulfilment_client.get_order_status(@order_id)

    if(status_details.key? 'error')
      @error = error_message[status_details['error']]
      logger.error("Error: #{@error}")
      logger.error("Status: #{status_details[:status]}")
      logger.error("Message: #{status_details[:message]}") if status_details[:message]
      logger.error("Body: #{status_details[:body]}") if status_details[:body]
      haml :track_form
    else
      haml :order_status, :locals => { :details => status_details[:body] }
    end
  end

  get '/env' do
    ENV.inspect
  end
end
