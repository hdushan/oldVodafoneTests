require 'sinatra/namespace'
require 'app_helper'
require 'fulfilment_client'
require 'haml'
require 'mega_menu/mega_menu_api_client'
require 'sinatra'
require 'sinatra_assets'
require 'user_agent'

class App < Sinatra::Base
  include Assets
  enable :logging

  def initialize(mega_menu_client=nil, fulfilment_client=nil)
    super()
    @fulfilment_client = fulfilment_client || FulfilmentClient.new
    @mega_menu_client = mega_menu_client || MegaMenuAPIClient.new
  end

  def mega_menu
    logger.info('Getting the Mega Menu')
    @is_mobile_user = UserAgent.parse(request.user_agent).mobile?
    puts UserAgent.parse(request.user_agent).inspect
    @mega_menu = @mega_menu_client.get_menu(@is_mobile_user)
    logger.info("MegaMenu fetched for #{ @is_mobile_user ? 'mobile' : 'desktop' }")
  end

  get '/tnt' do
    mega_menu

    haml :track_form
  end

  post '/tnt' do
    redirect "/tnt/#{params[:tracking_id].strip}"
  end

  get '/tnt/:id' do
    mega_menu

    # todo: needs more expressive errors coming out of this. I can't
    # tell the difference between a not found and a timeout
    status_details = @fulfilment_client.get_order_status params[:id]

    if(status_details.key? 'error')
      @error = error_message[status_details['error']]
      logger.error("Error: #{@error}")
      logger.error("Status: #{status_details[:status]}")
      logger.error("Message: #{status_details[:message]}") if status_details[:message]
      logger.error("Body: #{status_details[:body]}") if status_details[:body]
      halt 404, haml(:error)
    else
      haml :order_status, :locals => {:details => status_details[:body]}
    end
  end

  get '/env' do
    ENV.inspect
  end
end
