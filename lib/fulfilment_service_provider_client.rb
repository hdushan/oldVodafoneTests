require 'httparty'
require 'json'

class FulfilmentServiceProviderClient
  include HTTParty
  base_uri ENV['FULFILMENT_SERVICE']

  def get_order_status(order_id)
    if(order_id.empty?)
      { 'error' => 'ORDER_ID_EMPTY'}
    else
      begin
        JSON.parse(self.class.get("/order/#{order_id}").body)
      rescue
        { 'error' => 'INTERNAL_ERROR' }
      end
    end
  end
end