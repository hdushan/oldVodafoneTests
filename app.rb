require 'sinatra/namespace'
require 'app_helper'
require 'fulfilment_client'
require 'haml'
require 'mega_menu/mega_menu_api_client'
require 'sinatra'
require 'sinatra_assets'
require 'user_agent'
require 'fulfilment_response'
require 'message_mapper'

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
    begin
      mega_menu
      fulfilment_response = @fulfilment_client.get_order_details params[:id]

      if fulfilment_response.has_error?
        logger.error("Fulfilment Response: #{fulfilment_response}")
        @error = fulfilment_response.error_message
        halt fulfilment_response.code, haml(:error)
      else
        haml :order_status, :locals => {:details => fulfilment_response}
      end
    rescue Exception => exception
      logger.error(exception.message)
      logger.error(exception.backtrace.join("\n"))
      @error = MessageMapper::DEFAULT_ERROR_MESSAGE
      haml(:error)
    end
  end

  get '/env' do
    ENV.inspect
  end
end
