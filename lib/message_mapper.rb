class MessageMapper
  STATUS_MESSAGE_MAP = {
      'BACKORDERED' => 'Your order is on backorder',
      'CANCELLED' => 'Your order has been cancelled',
      'SHIPPED' => 'Your order has been shipped',
      'IN PROGRESS' => 'Your order is in progress'
  }

  ERROR_MESSAGE_MAP = {
      503 => 'Service Unavailable. Please, try again later.',
      404 => 'That order ID was not found. Please, check that you typed it correctly.'
  }

  DEFAULT_ERROR_MESSAGE = 'There was a problem retrieving your order.'

  def get_error_message(error_code)
    ERROR_MESSAGE_MAP[error_code] || DEFAULT_ERROR_MESSAGE
  end

  def get_status_message(status)
    STATUS_MESSAGE_MAP[status] || (raise "Invalid Order Status returned from Fusion: #{status}")
  end
end