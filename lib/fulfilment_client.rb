require 'hyperclient'
require 'faraday_monkeypatch' if File.exists? '/etc/trackandtrace_do_monkeypatch'

class FulfilmentClient
  def initialize(root = nil)
    @client = Hyperclient.new(root || ENV['FULFILMENT_SERVICE'])
  end

  def get_order_details(order_id, ip_address)
    raise ArgumentError, 'order_id empty' if order_id.empty?

    http_response = request_order_status(order_id, ip_address)
    FulfilmentResponse.new(http_response.status, http_response.body)
  end

  private
  def request_order_status(tracking_number, ip_address)
    @client.connection.headers['X-Forwarded-For'] = ip_address
    @client.links.order.expand(id: tracking_number).get
  end
end
