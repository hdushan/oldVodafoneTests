class MessageMapper

  include StatusStrings

  STATUS_MESSAGE_MAP = {
    TS_BACKORDERED => ['On backorder.', 'We’re currently waiting for more stock of your item to come in. We’ll get in touch the moment it arrives.'],
    TS_CANCELLED => ['Order cancelled.', 'You haven’t been charged for this order. If you need more info, call us on 1555 from your Vodafone mobile or 1300 650 410 from any other phone.'],
    TS_SHIPPED => ['Order shipped.', nil],
    TS_PROGRESS => ['Order pending.', 'Check back soon for an update on your order status.'],
    TS_PARTIALLY_SHIPPED => ['Partially shipped.', 'Part of your order is on its way. Check the status for each other item in your order below.'],
  }

  ITEM_STATUS_MESSAGE_MAP = {
    IS_BACKORDERED => 'On backorder.',
    IS_CANCELLED => 'Cancelled.',
    IS_SHIPPED => 'Shipped.',
    IS_PROGRESS => 'Pending.',
  }

  ERROR_HEADING_MAP = {
    503 => 'Something didn’t go as planned.',
    400 => 'Invalid tracking number.',
    404 => 'Invalid tracking number.',
  }

  ERROR_MESSAGE_MAP = {
    503 => 'Please check back soon.',
    400 => 'Please check that you’ve entered your tracking number exactly as it appears on your order receipt.',
    404 => 'Please check that you’ve entered your tracking number exactly as it appears on your order receipt.',
  }

  DEFAULT_ERROR_HEADING = 'Something didn’t go as planned.'
  DEFAULT_ERROR_MESSAGE = 'Please check back soon.'
  SHIPPING_ESTIMATE_MESSAGE = 'Expected delivery time.'

  def error_message(error_code)
    ERROR_MESSAGE_MAP[error_code] || DEFAULT_ERROR_MESSAGE
  end

  def error_heading(error_code)
    ERROR_HEADING_MAP[error_code] || DEFAULT_ERROR_HEADING
  end

  def default_error_message
    DEFAULT_ERROR_MESSAGE
  end

  def default_error_heading
    DEFAULT_ERROR_HEADING
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
