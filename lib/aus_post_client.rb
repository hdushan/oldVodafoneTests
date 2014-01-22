require 'logger'

class AusPostClient

  include HTTParty
  base_uri ENV['AUSPOST_BASE_URI']
  basic_auth ENV['AUSPOST_USERNAME'], ENV['AUSPOST_PASSWORD']
  cookies 'OBBasicAuth' => 'fromDialog'
  debug_output $stdout

  def track(consignment_id)
    response = self.class.get("/myapi/QueryTracking.json?q=#{consignment_id}")
    AusPostResponse.new(response)
  end
end
