def error_message
  error_message = {
    'FUSION_TIMEOUT'  => 'System timeout.',
    'ORDER_NOT_FOUND' => 'Order not found.',
    'ORDER_ID_EMPTY'  => 'You must provide order number.',
    'INVALID_FORMAT'  => 'Order id invalid.'
  }
  error_message.default = 'Internal error. Sorry'
  error_message
end

def nil_or_empty? string
  string.nil? || string.empty?
end
