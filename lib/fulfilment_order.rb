class FulfilmentOrder

  def initialize(fulfilment_response_order)
    @body = fulfilment_response_order
    @message_mapper = MessageMapper.new
  end

  def status_message
    return MessageMapper::AUSPOST_STATUS_MESSAGE if use_auspost_status?
    @message_mapper.status_message(tracking_status)
  end

  def tracking_status
    @body["tracking_status"]
  end

  def status_heading
    return tracking['status'] if use_auspost_status?
    @message_mapper.status_heading(tracking_status)
  end

  def use_auspost_status?
    tracking && tracking['status']
  end

  def tracking
    @body['tracking']
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
    tracking['events'] && tracking['events'].any?
  end

  def has_auspost_issue?
    auspost_business_exception? || auspost_error?
  end



end