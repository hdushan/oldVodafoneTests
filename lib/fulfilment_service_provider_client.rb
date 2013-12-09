require 'httparty'
require 'json'

class FulfilmentServiceProviderClient
  include HTTParty
  base_uri ENV['FULFILMENT_SERVICE']

  def get_order_status(order_id)
    JSON.parse(self.class.get("/order/#{order_id}").body)
  end
end