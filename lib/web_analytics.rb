

class WebAnalytics

  def initialize(tracking_id, fulfilment_response)
    @tracking_id = tracking_id
    @fulfilment_response = fulfilment_response
  end

  def to_json
    status_details = {
        'trackingID' => @tracking_id,
        'orderStatus' => order_status_string
    }
    status_details['auspostStatus'] = tracking_status_string unless trackable_orders.empty?
    [ 'tnt', status_details ]
  end

  def error_json
    [ 'tnt', { 'trackingID' => @tracking_id, 'orderStatus' => 'error' } ]
  end
private
  def tracking_status_string
    return 'error' if @fulfilment_response.has_error?

    status_string = trackable_orders.map do |order|
      order.auspost_status_heading
    end
    status_string.join(',').downcase.gsub(' ', '_')
  end

  def trackable_orders
    @fulfilment_response.orders.select { |order| order.tracking }
  end

  def order_status_string
    return 'error' if @fulfilment_response.has_error?
    status_string = @fulfilment_response.orders.map { |order| order.tracking_status }.join(',')
    status_string.downcase.gsub(' ', '_')
  end
end