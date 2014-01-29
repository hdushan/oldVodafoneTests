require 'httparty'
require 'json'
require 'logger'

class FulfilmentServiceProviderClient
  include HTTParty
  base_uri ENV['FULFILMENT_SERVICE']

  def get_order_details(order_id)
    raise 'Order ID empty' if order_id.empty?

    http_response = self.class.get("/order/#{order_id}")
    FulfilmentResponse.new(http_response.code, http_response.body)
  end
end