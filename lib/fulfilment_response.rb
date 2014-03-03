class FulfilmentResponse

  attr_reader :code
  attr_reader :orders

  def initialize(response_code, response_body)
    @code = response_code
    @body = response_body
    @orders = initialise_orders
    @message_mapper = MessageMapper.new
  end

  def order_number
    @body['order_number'] || ''
  end

  def initialise_orders
    return [] unless @body
    order_list = @body['orders'] || []
    order_list.inject([]) do
      |orders, order_response|
      orders.push(FulfilmentOrder.new(order_response))
      orders
    end
  end

  def has_error?
    @code != 200
  end

  def error_message
    @message_mapper.error_message(@code) if has_error?
  end

  def to_s
     "HTTP response code: #{@code}\n
      Body: '#{@body}\n
      #{has_error? ? error_message : ''}"
  end

end
