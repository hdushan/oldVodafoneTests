require 'httparty'
require 'json'
require 'logger'

class FulfilmentServiceProviderClient
  include HTTParty
  base_uri ENV['FULFILMENT_SERVICE']

  def get_order_status(order_id)
    if(order_id.empty?)
      { status: 400, 'error' => 'ORDER_ID_EMPTY' }
    else
      begin
        response = self.class.get("/order/#{order_id}")
        body = response.body
        reply = {status: response.code}
        error_hash = body['error']
        reply.store('error', error_hash['error']) if error_hash
        reply.store(:body, JSON.parse(body))
        reply
      rescue Exception => ex
        { status: 500, 'error' => 'INTERNAL_ERROR', message: ex.message }
      end
    end
  end
end