require 'httparty'
require 'json'

class FulfilmentServiceProviderClient
  include HTTParty
  base_uri 'http://10.0.2.2:9394'

  def get_order_status(order_id)
    responce_json = JSON.parse(self.class.get("/order/#{order_id}").body)

    if(responce_json['error'].nil?)
      responce_json.to_s
    else
      responce_json['error']
    end
  end
end