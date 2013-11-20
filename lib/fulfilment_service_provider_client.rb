require 'httparty'
require 'json'

class FulfilmentServiceProviderClient
  include HTTParty
  base_uri 'http://FulfilmentServiceProvider'

  def get_order_status(order_id)
    responce_json = JSON.parse(self.class.get("/order/#{order_id}").body)

    if(responce_json['error'].nil?)
      # TODO handle correct responce
    else
      responce_json['error']
    end
  end
end