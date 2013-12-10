def error_message
  error_message = {
    'FUSION_TIMEOUT' => 'System timeout.',
    'ORDER_NOT_FOUND' => 'Order not found.'
  }
  error_message.default = 'Internal error. Sorry'
  error_message
end