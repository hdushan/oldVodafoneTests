require 'hyperclient'
require 'json'
require 'logger'

class FulfilmentClient
  def initialize(root = nil)
    @client = Hyperclient.new(root || ENV['FULFILMENT_SERVICE'])
  end

  def get_order_status(order_id)
    return { status: 400, 'error' => 'ORDER_ID_EMPTY' } if order_id.empty?

    response = request_order_status order_id
    reply = {status: response.status}
    response_json = response.body
    if response_json['error']
      reply.store('error', response_json['error'])
    else
      reply.store(:body, response_json)
    end
    reply
  rescue => ex
    { status: 500, 'error' => 'INTERNAL_ERROR', message: ex.message }
  end

  private
  def request_order_status(tracking_number)
    @client.links.order.expand(id: tracking_number).get
  end
end
