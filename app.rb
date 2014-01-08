require 'sinatra'
require "sinatra/namespace"
require 'haml'
require 'user_agent'

require_relative 'sinatra_assets'
require_relative 'lib/fulfilment_service_provider_client'
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

  before /^\/(tnt|track|auth)$/  do
    logger.info('Getting the Mega Menu')
    @is_mobile_user = UserAgent.parse(request.user_agent).mobile?
    @mega_menu = @mega_menu_client.get_menu(@is_mobile_user)
    logger.info("MegaMenu fetched for #{ @is_mobile_user ? 'mobile' : 'desktop' }")
  end

  get '/tnt' do
    logger.info('Tnt request received')
    haml :track_form
  end

  post '/track' do
    @order_id = params[:tracking_id].strip
    status_details = @fulfilment_client.get_order_status(@order_id)

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

  get '/env' do
    ENV.inspect
  end
end