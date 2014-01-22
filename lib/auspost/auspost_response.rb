

class AusPostResponse

  def initialize(response)
    @response = response
  end

  def has_error?
    !error_message.nil?
  end

  def error_message
    begin
       if @response.code == 503
         "AusPost Service is not Unavailable"
       elsif @response.code != 200
         "Failed to get data from AusPost"
       elsif tracking_result["BusinessException"]
         tracking_result["BusinessException"]["Description"]
       end
    rescue Exception => ex
       puts ex.inspect
       return 'Unable to get information from AustraliaPost. Please, try again later'
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
            'date_time' => map_date_time(event['EventDateTime']),
            'location' => event['Location'],
            'description' => event['EventDescription'],
            'signer' => event['SignerName']
        }
      end
  end

private
  def tracking_result
    return nil if @response.parsed_response.nil?
    result = @response.parsed_response["QueryTrackEventsResponse"]["TrackingResult"]
    return result.first if result.class == Array
    result
  end

  def article_details
    tracking_result['ArticleDetails']
  end

  def map_date_time(date_time)
    return 'N/A' if date_time.nil?
    begin
      DateTime.strptime(date_time).strftime("%d/%m/%Y %I:%M%p")
    rescue Exception => ex
      logger.info("Failed to convert date: #{ex.inspect}")
      'N/A'
    end
  end
end