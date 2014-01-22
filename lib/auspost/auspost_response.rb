

class AusPostResponse

  def initialize(response)
    @response = response
  end

  def has_error?
    !error_message.nil?
  end

  def error_message
     if @response.code == 503
       "AusPost Service is not Unavailable"
     elsif @response.code != 200
       "Failed to get data from AusPost"
     elsif tracking_result["BusinessException"]
       tracking_result["BusinessException"]["Description"]
     end
  end

  def international?
    article_details['ProductName'] == 'International'
  end

  def status
    article_details['Status']
  end

  def events
      (article_details['Events'] || {'Event' => []})['Event'].map do |event|
        {
            'date_time' => event['EventDateTime'],
            'location' => event['Location'],
            'description' => event['EventDescription'],
            'signer' => event['SignerName']
        }
      end
  end

private
  def tracking_result
    return nil if @response.parsed_response["QueryTrackEventsResponse"].nil?
    result = @response.parsed_response["QueryTrackEventsResponse"]["TrackingResult"]
    return result.first if result.class == Array
    result
  end

  def article_details
    tracking_result['ArticleDetails']
  end

end