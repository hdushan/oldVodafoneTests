

class Shipment

  def initialize(tracking_details)
    @body = tracking_details
  end

  def auspost_status_heading
    @body['status']
  end

  def international?
    @body['international']
  end

  def events
    @body['events']
  end

  def has_tracking?
    not (events.nil? || events.empty?)
  end
end