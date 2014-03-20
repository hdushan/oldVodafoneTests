require 'sinatra/namespace'
require 'redis-sinatra'
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
require 'web_analytics'
require 'logger'
require 'git'
require 'app-version'

LOGGING_BLACKLIST = %w(/health_check)

class App < Sinatra::Base
  include Assets

  enable :logging
  set :logging, Logger::DEBUG
  set :cache, ENV['REDIS_URL'] ? Sinatra::Cache::RedisStore.new(ENV['REDIS_URL']) : nil
  disable :show_exceptions

  def initialize(app_hostname_list=[], mega_menu_client=nil, fulfilment_client=nil)
    super()
    @fulfilment_client = fulfilment_client
    @mega_menu_client = mega_menu_client || MegaMenuAPIClient.new
    @app_hostname_list = app_hostname_list
    @messages = MessageMapper.new
  end

  before do
    logger.level = Logger.const_get(ENV['LOG_LEVEL'] || 'WARN')
  end

  def mega_menu
    unless ENV['MEGA_MENU'] == 'OFF'
      @mega_menu = cached_result("mega-menu") {
        logger.info('Fetching MegaMenu')
        @mega_menu_client.get_menu
      }
    end
  rescue
    logger.error('Failed to fetch MegaMenu while handling an error')
  end

  def client_ip
    @env['HTTP_X_FORWARDED_FOR'] || request.ip
  end

  get '/tracking/' do
    redirect '/tracking'
  end

  get '/tracking/:id/' do
    redirect "/tracking/#{params[:id]}"
  end

  get '/health_check' do
    'OK'
  end

  get '/tracking' do
    mega_menu
    @analytics_page_name = 'home'
    @validation_error_msg = @messages.error_message(400)
    @error_heading = @messages.error_heading(400)
    haml :track_form
  end

  get '/shared_content/flush_cache' do
    settings.cache.delete cache_key('mega-menu') if settings.cache
    'Shared Content Flushed OK'
  end

  get '/cs/static/img/mobile/:img_file' do
    redirect "http://www.vodafone.com.au/cs/static/img/mobile/#{params[:img_file]}"
  end

  post '/tracking' do
    verify_referer
    redirect "/tracking/#{params[:tracking_id].strip}"
  end

  get '/tracking/trackingtermsconditions' do
    mega_menu
    haml :trackingtermsconditions
  end

  get '/tracking/:id' do
    mega_menu
    fulfilment_response = fulfilment.get_order_details params[:id], client_ip
    web_analytics(params[:id], fulfilment_response)

    if fulfilment_response.has_error?
      logger.error("Fulfilment Response: #{fulfilment_response}")
      @error = fulfilment_response.error_message
      @error_heading = fulfilment_response.error_heading
      @order_id = params[:id]
      halt fulfilment_response.code, haml(:track_form)
    else
      haml :order_status, :locals => {:order => fulfilment_response}
    end
  end

  error do
    mega_menu
    exception = env['sinatra.error']
    logger.error("error=#{exception.message}")
    logger.error(exception.backtrace.join("\n"))
    @error = @messages.default_error_message
    @error_heading = @messages.default_error_heading
    @analytics_page_name = 'result'
    @analytics_data = WebAnalytics.new(params[:id], nil).error_json
    haml(:track_form)
  end

  private

  def web_analytics(tracking_id, fulfilment_response)
    @analytics_page_name = 'result'
    @analytics_data = WebAnalytics.new(tracking_id, fulfilment_response).to_json
  end

  def fulfilment
    @fulfilment_client ||= FulfilmentClient.new(logger)
  end

  def verify_referer
    if request.referrer.nil? || !@app_hostname_list.include?(URI.parse(request.referrer).host)
      halt 400, 'Invalid request'
    end
  end
end
