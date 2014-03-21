require 'hyperclient'
require 'rack/timeout'
require 'faraday_monkeypatch' if File.exists? '/etc/trackandtrace_do_monkeypatch'

class FulfilmentClient
  def initialize(logger, root = nil)
    @client = Hyperclient.new(root || ENV['FULFILMENT_SERVICE'])
    @logger = logger
  end

  def get_order_details(order_id, ip_address)
    raise ArgumentError, 'order_id empty' if order_id.empty?
    @logger.info "[trackandtrace] trackShippingStatus=#{order_id}"
    http_response = request_order_status(order_id, ip_address)
    @logger.info "[trackandtrace] trackShippingStatus=#{order_id} complete"
    FulfilmentResponse.new(http_response.status, http_response.body)
  end

  private
  def request_order_status(tracking_number, ip_address)
    @logger.debug "Looking for links at #{@client.inspect}"
    @client.connection.headers['X-Forwarded-For'] = ip_address
    @client.links.order.expand(id: tracking_number).get
  rescue Rack::Timeout::RequestTimeoutError => ex
    @logger.error "Request to #{@client.inspect} timed out"
    raise ex
  rescue => ex
    @logger.error "No links found in response #{@client.get.body}"
    raise ex
  end
end
