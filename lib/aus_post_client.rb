require 'logger'

class AusPostClient

  include HTTParty
  base_uri 'https://devcentre.auspost.com.au'
  cookies 'OBBasicAuth' => 'fromDialog'
  debug_output $stdout

  def initialize(username, password)
    @username = username
    @password = password
  end

  def track(consignment_id)
    begin
      response = self.class.get("/myapi/QueryTracking.xml?q=#{consignment_id}", {basic_auth: { username: @username, password: @password}})
      if response.parsed_response.nil?
        return { status: response.code, error: 'Service Unavailable or Consignment ID is not valid'}
      end
      unless response.parsed_response["QueryTrackEventsResponse"]
        return { status: response.code, error: response.parsed_response }
      end

      tracking_result = response.parsed_response["QueryTrackEventsResponse"]["TrackingResult"]
      if tracking_result && tracking_result["BusinessException"]
        { status: tracking_result["BusinessException"]["Code"], error: tracking_result["BusinessException"]["Description"] }
      else
        { status: response.code, body: tracking_result }
      end
    rescue Exception => ex
      { status: 500, 'error' => 'INTERNAL_ERROR', message: ex.message }
    end
  end
end
