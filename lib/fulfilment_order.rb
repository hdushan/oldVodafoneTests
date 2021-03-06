class FulfilmentOrder

  include StatusStrings

  def initialize(fulfilment_response_order)
    @body = fulfilment_response_order
    @message_mapper = MessageMapper.new
  end

  def status_message
    @message_mapper.status_message(tracking_status)
  end

  def tracking_status
    @body["tracking_status"]
  end

  def status_heading
    @message_mapper.status_heading(tracking_status)
  end

  def shipments
    @shipments ||= (tracking['articles'] || []).map { |article| Shipment.new(article) }
  end

  def auspost_number
    @body['consignment_number']
  end

  def international?
    shipments.any? { |shipment| shipment.international? }
  end

  def items
    return [] unless @body["items"]
    @body["items"].inject([]) do |items, item|
      items << {:item_quantity => item["item_quantity"], :description => item["description"], :status => @message_mapper.item_status(item["status"])}
    end
  end

  def is_on_backorder?
    tracking_status == TS_BACKORDERED
  end

  def estimated_shipping_date
    Date.parse(@body["estimated_shipping_date"]).strftime('%d %B %Y') if @body["estimated_shipping_date"]
  end

  def shipping_estimate_message
    MessageMapper::SHIPPING_ESTIMATE_MESSAGE if is_on_backorder? && !estimated_shipping_date
  end

  def auspost_error?
    !tracking['error'].nil?
  end

  def auspost_business_exception?
    !tracking['business_exception'].nil?
  end

  def show_tracking_info?
    tracking && (has_tracking_events? || has_auspost_issue?)
  end

  def has_tracking_events?
    shipments.map { |shipment| shipment.has_tracking? }.any?
  end

  def has_auspost_issue?
    auspost_business_exception? || auspost_error?
  end

private
  def tracking
    @body['tracking'] || {}
  end
end