require 'spec_helper'

describe Shipment do

  let(:shipment) do
    shipment = Shipment.new({'international' => false, 'status' => 'Delivered',
                             'events' => [
                                 {'date_time' => '21/06/2010 12=>21PM', 'location' => '224952 work centre', 'description' => 'Delivered', 'signer' => nil},
                                 {'date_time' => '21/06/2010 12=>12PM', 'location' => '224952 work centre', 'description' => 'Delivered', 'signer' => nil},
                                 {'date_time' => '10/12/2008 12=>12PM', 'location' => 'PROP - PROPERTY DEVELOPMENTS', 'description' => 'Delivered', 'signer' => 'A POST'}
                             ]})
  end

  it 'should return the tracking details' do
    shipment.international?.should be_false
    shipment.events.should have(3).items
    shipment.events.first['date_time'].should eq('21/06/2010 12=>21PM')
    shipment.has_tracking?.should be_true
  end

  it 'should show the AusPost tracking status' do
    shipment.auspost_status_heading.should eq('Delivered')
  end
end