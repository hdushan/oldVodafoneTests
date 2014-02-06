class MessageMapper
  STATUS_MESSAGE_MAP = {
      'BACKORDERED' => ['On Backorder', 'Your order is on backorder'],
      'CANCELLED' => ['Order Cancelled', 'Your order has been cancelled'],
      'SHIPPED' => ['Order Shipped', 'Your order has been shipped'],
      'IN PROGRESS' => ['In Progress', 'Your order is in progress'],
  }

  ERROR_MESSAGE_MAP = {
      503 => 'Service Unavailable. Please, try again later.',
      403 => 'Invalid order ID, check that you typed it correctly.',
      404 => 'That order ID was not found. Please, check that you typed it correctly.',
  }

  DEFAULT_ERROR_MESSAGE = 'There was a problem retrieving your order.'

  SHIPPING_ESTIMATE_MESSAGE = 'Your order will arrive soon';

  def error_message(error_code)
    ERROR_MESSAGE_MAP[error_code] || DEFAULT_ERROR_MESSAGE
  end

  def status_message(status)
    validate_status(status)
    STATUS_MESSAGE_MAP[status].last
  end

  def status_heading(status)
    validate_status(status)
    STATUS_MESSAGE_MAP[status].first
  end

private
  def validate_status(status)
    raise "Invalid Order Status returned from Fusion: #{status}" unless STATUS_MESSAGE_MAP[status]
  end
end
