class FulfilmentResponse

  attr_reader :code

  def initialize(response_code, response_body)
    @code = response_code
    @body = response_body
    @message_mapper = MessageMapper.new
  end

  def has_error?
    @code != 200
  end

  def error_message
    @message_mapper.get_error_message(@code) if has_error?
  end

  def status
    @message_mapper.get_status_message(@body["tracking_status"])
  end

  def to_s
     "HTTP response code: #{@code}\n
      Body: '#{@body}\n
      #{has_error? ? error_message : ''}"
  end
end