class MessageMapper

  include StatusStrings

  STATUS_MESSAGE_MAP = {
    TS_BACKORDERED => ['On Backorder', 'Your order has been placed on backorder. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nost.'],
    TS_CANCELLED => ['Order Cancelled', 'Your order has been cancelled. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nost.'],
    TS_SHIPPED => ['Order Shipped', ''],
    TS_PROGRESS => ['In Progress', ''],
    TS_PARTIALLY_SHIPPED => ['Order Partially Shipped', 'Your order has been partially shipped. Check the status of each item below.'],
  }

  ITEM_STATUS_MESSAGE_MAP = {
    IS_BACKORDERED => 'On Backorder',
    IS_CANCELLED => 'Cancelled',
    IS_SHIPPED => 'Shipped',
    IS_PROGRESS => 'In Progress',
  }

  ERROR_MESSAGE_MAP = {
    503 => 'Service Unavailable. Please, try again later.',
    403 => 'Invalid order ID, check that you typed it correctly.',
    404 => 'That order ID was not found. Please, check that you typed it correctly.',
  }

  DEFAULT_ERROR_MESSAGE = 'There was a problem retrieving your order.'
  AUSPOST_STATUS_MESSAGE = ''
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

  def item_status(status)
    ITEM_STATUS_MESSAGE_MAP[status] || ''
  end

  private
  def validate_status(status)
    raise "Invalid Order Status returned from Fusion: #{status}" unless STATUS_MESSAGE_MAP[status]
  end
end
