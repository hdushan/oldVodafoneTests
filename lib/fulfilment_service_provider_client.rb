require 'httparty'
require 'json'

class FulfilmentServiceProviderClient
  include HTTParty
  base_uri 'http://FulfilmentServiceProvider'

  def get_order_status
    JSON.parse(self.class.get("/order/123").body)['status']
  end
end