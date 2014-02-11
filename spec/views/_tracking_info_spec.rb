require 'spec_helper'

describe '_tracking_info.haml' do

  context 'has no events in tracking information' do
    let(:tracking_info) { {'foo' => 'bar'} }
    before do
      render("/views/_tracking_info.haml", :tracking => tracking_info)
    end

    it 'should not display tracking information' do
      page.should have_no_selector('.tracking-info')
    end
  end

  context 'has three events in tracking information' do
    let(:tracking_info) { {'international' => false, 'status' => 'Delivered', 'events' => [
        {'date_time' => '21/06/2010 12=>21PM', 'location' => '224952 work centre', 'description' => 'Delivered', 'signer' => nil},
        {'date_time' => '21/06/2010 12=>12PM', 'location' => '224952 work centre', 'description' => 'Redirected', 'signer' => nil},
        {'date_time' => '10/12/2008 12=>12PM', 'location' => 'PROP - PROPERTY DEVELOPMENTS', 'description' => 'Signed', 'signer' => 'A POST'}
    ]} }
    before do
      render("/views/_tracking_info.haml", :tracking => tracking_info)
      #puts response
    end

    it 'should display tracking information' do
      page.should have_selector('.tracking-info')
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
