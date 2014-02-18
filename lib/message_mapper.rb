class MessageMapper

  include StatusStrings

  STATUS_MESSAGE_MAP = {
    TS_BACKORDERED => ['On Backorder', 'Your order is on backorder'],
    TS_CANCELLED => ['Order Cancelled', 'Your order has been cancelled'],
    TS_SHIPPED => ['Order Shipped', 'Your order has been shipped'],
    TS_PROGRESS => ['In Progress', 'Your order is in progress'],
    TS_PARTIALLY_SHIPPED => ['Order Partially Shipped', 'Your order has been partially shipped'],
  }

  ERROR_MESSAGE_MAP = {
    503 => 'Service Unavailable. Please, try again later.',
    403 => 'Invalid order ID, check that you typed it correctly.',
    404 => 'That order ID was not found. Please, check that you typed it correctly.',
  }

  DEFAULT_ERROR_MESSAGE = 'There was a problem retrieving your order.'
  AUSPOST_STATUS_MESSAGE = "See below for further information about your order's travels"
  SHIPPING_ESTIMATE_MESSAGE = 'Your order will arrive soon'

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
