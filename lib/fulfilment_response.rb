class FulfilmentResponse

  attr_reader :code

  def initialize(response_code, response_body)
    @code = response_code
    @body = response_body
    @message_mapper = MessageMapper.new
  end

  def has_error?
    @code != 200
  end

  def error_message
    @message_mapper.error_message(@code) if has_error?
  end

  def status_message
    @message_mapper.status_message(@body["tracking_status"])
  end

  def status_heading
    @message_mapper.status_heading(@body["tracking_status"])
  end

  def items
    return [] unless @body["items"]
    @body["items"].inject([]) do |items, item|
      items << {:item_quantity => item["item_quantity"], :description => item["description"]}
    end
  end

  def order_number
    @body['order_number'] || ''
  end

  def is_on_backorder?
    @body["tracking_status"] == 'BACKORDERED'
  end

  def estimated_shipping_date
    Date.parse(@body["estimated_shipping_date"]).strftime('%d %B %Y') if @body["estimated_shipping_date"]
  end

  def shipping_estimate_message
    MessageMapper::SHIPPING_ESTIMATE_MESSAGE if is_on_backorder? && !estimated_shipping_date
  end

  def to_s
     "HTTP response code: #{@code}\n
      Body: '#{@body}\n
      #{has_error? ? error_message : ''}"
  end
end