require 'httparty'
require 'json'
require 'logger'

class FulfilmentClient
  include HTTParty
  base_uri ENV['FULFILMENT_SERVICE']

  def get_order_status(order_id)
    if(order_id.empty?)
      { status: 400, 'error' => 'ORDER_ID_EMPTY' }
    else
      begin
        response = self.class.get("/order/#{order_id}")
        reply = {status: response.code}
        response_json = JSON.parse(response.body)
        if response_json['error']
          reply.store('error', response_json['error'])
        else
          reply.store(:body, response_json)
        end
        reply
      rescue Exception => ex
        { status: 500, 'error' => 'INTERNAL_ERROR', message: ex.message }
      end
    end
  end
end
