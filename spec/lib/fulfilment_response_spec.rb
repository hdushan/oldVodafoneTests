require 'spec_helper'

include StatusStrings

describe FulfilmentResponse do

  describe '#has_error?' do
    it 'should return true if response code is not 200' do
      response = FulfilmentResponse.new(987, {})
      response.has_error?.should be_true
    end

    it 'should return false if response is 200' do
      response = FulfilmentResponse.new(200, {})
      response.has_error?.should be_false
    end
  end

  describe '#error_message' do
    it 'should return generic error message if 503 error occurred' do
      response = FulfilmentResponse.new(503, 'this could be anything')
      response.error_message.should == 'Service Unavailable. Please, try again later.'
    end

    it 'should return nil if no error occurred' do
      response = FulfilmentResponse.new(200, {'order_number' => 'VF123FOUND', 'tracking_status' => TS_PROGRESS})
      response.error_message.should be_nil
    end
  end

  describe '#status_message' do
    it 'should map the status to a user friendly message' do
      response = FulfilmentResponse.new(200, {'order_number' => 'VF123FOUND', 'tracking_status' => TS_PROGRESS})
      response.status_message.should == 'Your order is in progress'
    end
  end

  describe '#status_heading' do
    it 'should map the status to a user friendly header' do
      response = FulfilmentResponse.new(200, {'order_number' => 'VF123FOUND', 'tracking_status' => TS_PROGRESS})
      response.status_heading.should == 'In Progress'
    end
  end

  describe '#items' do
    it 'should map the shipping line items if present' do
      response = FulfilmentResponse.new(200, {'order_number' => 'VF123FOUND', 'tracking_status' => TS_PROGRESS, 'items' => [
          {'description' => 'iPhone', 'item_quantity' => '1', 'status' => IS_SHIPPED},
          {'description' => 'sim', 'item_quantity' => '2', 'status' => IS_CANCELLED}
      ]})
      response.items.first.should == {item_quantity: '1', description: 'iPhone', status: 'Shipped'}
      response.items.last.should == {item_quantity: '2', description: 'sim', status: 'Cancelled'}
    end

    it 'should return empty array if there are no shipping line items' do
      response = FulfilmentResponse.new(200, {'order_number' => 'VF123FOUND', 'tracking_status' => TS_PROGRESS})
      response.items.should == []
    end
  end

  describe '#order_number' do
    it 'should map the order number' do
      response = FulfilmentResponse.new(200, {'order_number' => 'VF123FOUND', 'tracking_status' => TS_PROGRESS})
      response.order_number.should == 'VF123FOUND'
    end

    it 'should return empty string if order_number is missing' do
      response = FulfilmentResponse.new(200, {'tracking_status' => TS_PROGRESS})
      response.order_number.should == ''
    end
  end

  describe 'backorders' do
    context 'when the estimated shipping date is present' do
      let(:response) { FulfilmentResponse.new(200, {'order_number' => 'VF123FOUND', 'tracking_status' => TS_BACKORDERED,
          'estimated_shipping_date' => '2014-07-13',
          'items' => [{'description' => 'iPhone', 'item_quantity' => '1'}]})
      }

      it 'should be on backorder' do
        response.is_on_backorder?.should be_true
      end

      it 'should format the date' do
        response.estimated_shipping_date.should eq('13 July 2014')
      end

      it 'should not show a shipping estimate message' do
        response.shipping_estimate_message.should be_nil
      end

    end

    context 'when the estimated shipping date is missing' do
      let(:response) { FulfilmentResponse.new(200, {'order_number' => 'VF123FOUND', 'tracking_status' => TS_BACKORDERED,
          'items' => [{'description' => 'iPhone', 'item_quantity' => '1'}]})
      }

      it 'should be on backorder' do
        response.is_on_backorder?.should be_true
      end

      it 'should not have a date' do
        response.estimated_shipping_date.should be_nil
      end

      it 'should show a shipping estimate message' do
        response.shipping_estimate_message.should eq('Your order will arrive soon')
      end
    end

  end

  describe '#tracking' do

    context 'when tracking data is complete and valid' do
      let(:response) { FulfilmentResponse.new(200,
          {'order_number' => 'VF123FOUND', 'tracking_status' => TS_SHIPPED, 'consignment_number' => 'AP123FOUND',
              'items' => [{'description' => 'iPhone 5C 16GB White', 'item_quantity' => '1'}],
              'ordered_date' => '2013-11-20',
              'tracking' => {'international' => false, 'status' => 'Delivered',
                  'events' => [
                      {'date_time' => '21/06/2010 12=>21PM', 'location' => '224952 work centre', 'description' => 'Delivered', 'signer' => nil},
                      {'date_time' => '21/06/2010 12=>12PM', 'location' => '224952 work centre', 'description' => 'Delivered', 'signer' => nil},
                      {'date_time' => '10/12/2008 12=>12PM', 'location' => 'PROP - PROPERTY DEVELOPMENTS', 'description' => 'Delivered', 'signer' => 'A POST'}
                  ]}, '_links' => {'self' => {'href' => 'http=>//192.168.1.102=>9393/v1/order/VF123FOUND'}}}
      ) }

      it 'should return the tracking details' do
        response.tracking['international'].should be_false
        response.tracking['status'].should eq('Delivered')
        response.tracking['events'].size.should be(3)
        response.tracking['events'].first['date_time'].should eq('21/06/2010 12=>21PM')
      end

      it 'should use the AusPost tracking status if present' do
        response.status_heading.should eq('Delivered')
      end

      it 'should use the AusPost tracking status message if present' do
        response.status_message.should eq("See below for further information about your order's travels")
      end
    end

    context 'when tracking data is in error' do
      let(:response) { FulfilmentResponse.new(200,
          {'order_number' => 'VF123FOUND', 'tracking_status' => TS_SHIPPED, 'consignment_number' => 'AP123FOUND',
              'items' => [{'description' => 'iPhone 5C 16GB White', 'item_quantity' => '1'}],
              'ordered_date' => '2013-11-20',
              'tracking' => {'error' => 'Failed to get data from AusPost'},
              '_links' => {'self' => {'href' => 'http=>//192.168.1.102=>9393/v1/order/VF123FOUND'}}}
      ) }

      it 'should use the vodafone status' do
        response.status_heading.should eq('Order Shipped')
      end

      it 'should use the vodafone status message' do
        response.status_message.should eq('Your order has been shipped')
      end
    end
  end

  describe '#show_tracking_events?' do

    it 'should return true if has tracking events' do
      response = FulfilmentResponse.new(200, {'tracking' => {'events' => ['kittens']} })
      response.show_tracking_events?.should be_true
    end

    it 'should return false if no tracking events' do
      response = FulfilmentResponse.new(200, {'tracking' => {} })
      response.show_tracking_events?.should be_false
    end

    it 'should return false if tracking events are empty' do
      response = FulfilmentResponse.new(200, {'tracking' => {'events' => []} })
      response.show_tracking_events?.should be_false
    end

    it 'should return false if tracking is nil' do
      response = FulfilmentResponse.new(200, {})
      response.show_tracking_events?.should be_false
    end

  end
end
