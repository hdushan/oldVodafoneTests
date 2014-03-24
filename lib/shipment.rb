

class Shipment

  def initialize(tracking_details)
    @body = tracking_details
  end

  def tracking
    @body
  end

  def auspost_status_heading
    tracking['status']
  end

  def international?
    tracking['international']
  end
end