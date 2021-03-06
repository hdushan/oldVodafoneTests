require 'spec_helper'

describe '_tracking_info.haml' do

  context 'has no events and no AusPost issues in tracking information' do
    let(:tracking_info) { double(Shipment, has_tracking?: false) }
    before do
      render("/views/_tracking_info.haml", :tracking => tracking_info)
    end

    it 'should not display events' do
      page.should have_no_selector('.events')
    end

    it 'should not display AusPost status message' do
      page.should have_no_selector('.auspost-status-message')
    end
  end

  context 'has three events in tracking information' do
    let(:tracking_info) { Shipment.new({'international' => false, 'status' => 'Delivered', 'events' => [
        {'date_time' => '21/06/2010 12=>21PM', 'location' => '224952 work centre', 'description' => 'Delivered', 'signer' => nil},
        {'date_time' => '21/06/2010 12=>12PM', 'location' => '224952 work centre', 'description' => 'Redirected', 'signer' => nil},
        {'date_time' => '10/12/2008 12=>12PM', 'location' => 'PROP - PROPERTY DEVELOPMENTS', 'description' => 'Signed', 'signer' => 'A POST'}
      ]}) }
    before do
      render("/views/_tracking_info.haml", :tracking => tracking_info, :auspost_error => false, :auspost_business_exception => false)
      #puts response
    end

    it 'should display tracking events' do
      page.should have_selector('.tracking-info')
      page.should have_selector('.events')
      headers = page.all('th')
      headers.size.should be(2)
      headers.first.should have_content('Date/Time')
      headers.last.should have_content('Status')
      dates = page.all('.event-date')
      dates.size.should be(3)
      dates[0].should have_content('21/06/2010 12=>21PM')
      dates[1].should have_content('21/06/2010 12=>12PM')
      dates[2].should have_content('10/12/2008 12=>12PM')
      statuses = page.all('.event-status')
      statuses.size.should be(3)
      statuses[0].should have_content('Delivered')
      statuses[1].should have_content('Redirected')
      statuses[2].should have_content('Signed')
    end
  end

end
