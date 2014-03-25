class MessageMapper

  include StatusStrings

  STATUS_MESSAGE_MAP = {
    TS_BACKORDERED => ['On backorder.', 'We’re currently waiting for more stock to come in. We’ll get in touch the moment they arrive.'],
    TS_CANCELLED => ['Order cancelled.', 'You haven’t been charged for this order. If you need more info, call us on 1555 from your Vodafone mobile or 1300 650 410 from any other phone.'],
    TS_SHIPPED => ['Order shipped.', nil],
    TS_PROGRESS => ['We’re working on your order.', 'Check back soon for an update on your order status.'],
    TS_PARTIALLY_SHIPPED => ['Partially shipped.', 'Part of your order is on its way. Details for each item is listed below.'],
    TS_RETURN => ['Return in progress.', nil],
    TS_RETURNED => ['Order returned.', nil]
  }

  ITEM_STATUS_MESSAGE_MAP = {
    IS_BACKORDERED => 'On backorder.',
    IS_CANCELLED => 'Cancelled.',
    IS_SHIPPED => 'Shipped.',
    IS_PROGRESS => 'Pending.',
    IS_RETURN => 'Return in progress.',
    IS_RETURNED => 'Returned.'
  }

  ERROR_HEADING_MAP = {
    503 => 'Something didn’t go as planned.',
    400 => 'Invalid tracking number.',
    404 => 'Invalid tracking number.',
  }

  ERROR_MESSAGE_MAP = {
    503 => 'Sorry, we’ve just had a technical mishap. Please try again in a few minutes.',
    400 => 'Please check that you’ve entered your tracking number exactly as it appears on your order receipt.',
    404 => 'Please check that you’ve entered your tracking number exactly as it appears on your order receipt.',
  }

  DEFAULT_ERROR_HEADING = 'Something didn’t go as planned.'
  DEFAULT_ERROR_MESSAGE = 'Sorry, we’ve just had a technical mishap. Please try again in a few minutes.'
  DEFAULT_AUSPOST_HEADING = 'It’s on the truck.'

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

  def default_auspost_heading
    DEFAULT_AUSPOST_HEADING
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
