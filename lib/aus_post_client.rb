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
    response = self.class.get("/myapi/QueryTracking.xml?q=#{consignment_id}",
                              { basic_auth: { username: @username,
                                              password: @password}})
    validate(response)
    tracking_details(response.parsed_response["QueryTrackEventsResponse"]["TrackingResult"])
  end

private
  def tracking_details(tracking_response)
    article_details = tracking_response['ArticleDetails']
    events = article_details['Events'] || {'Event' => []}
    {
        'international' => article_details['ProductName'] == 'International',
        'status' => article_details['Status'],
        'events' => events['Event'].map do |event|
          {
              'date_time' => event['EventDateTime'],
              'location' => event['Location'],
              'description' => event['EventDescription'],
              'signer' => event['SignerName']
          }
        end
    }
  end

  def validate(response)
    validate_response_present(response)

    validate_business_exception(response.parsed_response["QueryTrackEventsResponse"]["TrackingResult"])
  end

  def validate_response_present(response)
    if response.parsed_response.nil? || response.parsed_response["QueryTrackEventsResponse"].nil?
      raise "Failed to get data from AusPost: returned #{response.code}: " +
                (response.parsed_response || "Service Unavailable or Consignment ID is not valid")
    end
  end

  def validate_business_exception(tracking_result)
    if tracking_result["BusinessException"]
      raise "Failed to get data from AusPost: returned #{tracking_result["BusinessException"]["Code"]}: " +
                (tracking_result["BusinessException"]["Description"])
    end
  end
end
