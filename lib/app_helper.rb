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

def generate_auth_url status_details, order_id
  auth_type = auth_type(status_details['email'], status_details['date_of_birth'])
  auth_type.nil? ? nil : "/auth?order_id=#{order_id}&authType=#{auth_type}"
end

def auth_type email, date_of_birth
  return 'email' if !(nil_or_empty?email)
  return 'dob' if !(nil_or_empty?date_of_birth)
  return nil
end

def nil_or_empty? string
  string.nil? || string.empty?
end
