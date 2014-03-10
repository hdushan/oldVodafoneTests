require 'sinatra/namespace'
require 'app_helper'
require 'fulfilment_client'
require 'status_strings'
require 'haml'
require 'mega_menu/mega_menu_api_client'
require 'sinatra'
require 'sinatra_assets'
require 'user_agent'
require 'fulfilment_response'
require 'fulfilment_order'
require 'message_mapper'
require 'logger'

LOGGING_BLACKLIST = %w(/health_check)

class App < Sinatra::Base
  include Assets

  enable :logging
  set :logging, Logger::DEBUG
  disable :show_exceptions

  def initialize(mega_menu_client=nil, fulfilment_client=nil)
    super()
    @fulfilment_client = fulfilment_client
    @mega_menu_client = mega_menu_client || MegaMenuAPIClient.new
  end

  before do
    logger.level = Logger.const_get(ENV['LOG_LEVEL'] || 'WARN')
  end

  def mega_menu
    unless ENV['MEGA_MENU'] == 'OFF'
      logger.info('Getting the Mega Menu')
      @mega_menu = {}
      @mega_menu['mobile'] = @mega_menu_client.get_menu(true)
      @mega_menu['desktop'] = @mega_menu_client.get_menu(false)
    end
  end

  def client_ip
    @env['HTTP_X_FORWARDED_FOR'] || request.ip
  end

  get '/tnt/' do
    redirect '/tnt'
  end

  get '/tnt/:id/' do
    redirect "/tnt/#{params[:id]}"
  end

  get '/health_check' do
    'OK'
  end

  get '/tnt' do
    mega_menu

    haml :track_form
  end

  get '/cs/static/img/mobile/:img_file' do
    redirect "http://www.vodafone.com.au/cs/static/img/mobile/#{params[:img_file]}"
  end

  post '/tnt' do
    redirect "/tnt/#{params[:tracking_id].strip}"
  end

  get '/tnt/trackingtermsconditions' do
    mega_menu
    haml :trackingtermsconditions
  end

  get '/tnt/:id' do
    mega_menu
    fulfilment_response = fulfilment.get_order_details params[:id], client_ip

    if fulfilment_response.has_error?
      logger.error("Fulfilment Response: #{fulfilment_response}")
      @error = fulfilment_response.error_message
      halt fulfilment_response.code, haml(:track_form)
    else
      haml :order_status, :locals => {:order => fulfilment_response}
    end
  end

  error do
    exception = env['sinatra.error']
    logger.error("error=#{exception.message}")
    logger.error(exception.backtrace.join("\n"))
    @error = MessageMapper::DEFAULT_ERROR_MESSAGE
    haml(:track_form)
  end

  private

  def fulfilment
    @fulfilment_client ||= FulfilmentClient.new(logger)
  end
end
