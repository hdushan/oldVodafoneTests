require 'spec_helper'

include StatusStrings

describe FulfilmentOrder do

  describe '#status_message' do
    it 'should map the status to a user friendly message' do
      response = FulfilmentOrder.new({'tracking_status' => TS_CANCELLED})
      response.status_message.should match /Your order has been cancelled/
    end
  end


  describe '#status_heading' do
    it 'should map the status to a user friendly header' do
      response = FulfilmentOrder.new({'tracking_status' => TS_PROGRESS})
      response.status_heading.should == 'In Progress'
    end
  end

  describe '#items' do
    it 'should map the shipping line items if present' do
      response = FulfilmentOrder.new({'tracking_status' => TS_PROGRESS, 'items' => [
        {'description' => 'iPhone', 'item_quantity' => '1', 'status' => IS_SHIPPED},
        {'description' => 'sim', 'item_quantity' => '2', 'status' => IS_CANCELLED}
      ]})
      response.items.first.should == {item_quantity: '1', description: 'iPhone', status: 'Shipped'}
      response.items.last.should == {item_quantity: '2', description: 'sim', status: 'Cancelled'}
    end

    it 'should return empty array if there are no shipping line items' do
      response = FulfilmentOrder.new({'tracking_status' => TS_PROGRESS})
      response.items.should == []
    end
  end

  describe 'backorders' do
    context 'when the estimated shipping date is present' do
      let(:response) { FulfilmentOrder.new({'tracking_status' => TS_BACKORDERED,
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
      let(:response) { FulfilmentOrder.new({'tracking_status' => TS_BACKORDERED,
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
      let(:response) { FulfilmentOrder.new(
        {'tracking_status' => TS_SHIPPED, 'consignment_number' => 'AP123FOUND',
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

      it 'should flag no AusPost issues' do
        response.auspost_error?.should be_false
        response.auspost_business_exception?.should be_false
      end
    end

    context 'when tracking data is in error' do
      let(:response) { FulfilmentOrder.new(
        {'tracking_status' => TS_CANCELLED, 'consignment_number' => 'AP123FOUND',
          'items' => [{'description' => 'iPhone 5C 16GB White', 'item_quantity' => '1'}],
          'ordered_date' => '2013-11-20',
          'tracking' => {'error' => 'Failed to get data from AusPost'},
          '_links' => {'self' => {'href' => 'http=>//192.168.1.102=>9393/v1/order/VF123FOUND'}}}
      ) }

      it 'should use the vodafone status' do
        response.status_heading.should match /Order cancelled/i
      end

      it 'should use the vodafone status message' do
        response.status_message.should match /Your order has been cancelled/i
      end

      it 'should flag an AusPost error' do
        response.auspost_error?.should be_true
        response.auspost_business_exception?.should be_false
      end
    end

    context 'when tracking data has a business exception' do
      let(:response) { FulfilmentOrder.new(
        {'tracking_status' => TS_CANCELLED, 'consignment_number' => 'AP123FOUND',
          'items' => [{'description' => 'iPhone 5C 16GB White', 'item_quantity' => '1'}],
          'ordered_date' => '2013-11-20',
          'tracking' => {'business_exception' => 'Product is not trackable'},
          '_links' => {'self' => {'href' => 'http=>//192.168.1.102=>9393/v1/order/VF123FOUND'}}}
      ) }

      it 'should use the vodafone status' do
        response.status_heading.should match /Order cancelled/i
      end

      it 'should use the vodafone status message' do
        response.status_message.should match /Your order has been cancelled/i
      end

      it 'should flag an AusPost business exception' do
        response.auspost_error?.should be_false
        response.auspost_business_exception?.should be_true
      end
    end
  end

  describe '#show_tracking_info?' do

    it 'should return true if has tracking events' do
      response = FulfilmentOrder.new( {'tracking' => {'events' => ['kittens']} })
      response.show_tracking_info?.should be_true
    end

    it 'should return true if has an AusPost error' do
      response = FulfilmentOrder.new( {'tracking' => {'error' => 'puppies'} })
      response.show_tracking_info?.should be_true
    end

    it 'should return true if has an AusPost business exception' do
      response = FulfilmentOrder.new( {'tracking' => {'business_exception' => 'guppies'} })
      response.show_tracking_info?.should be_true
    end

    it 'should return false if no tracking events' do
      response = FulfilmentOrder.new( {'tracking' => {} })
      response.show_tracking_info?.should be_false
    end

    it 'should return false if tracking events are empty' do
      response = FulfilmentOrder.new( {'tracking' => {'events' => []} })
      response.show_tracking_info?.should be_false
    end

    it 'should return false if tracking is nil' do
      response = FulfilmentOrder.new( {})
      response.show_tracking_info?.should be_false
    end

  end

end