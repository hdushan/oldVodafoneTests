require 'spec_helper'

include StatusStrings

describe FulfilmentResponse do

  describe '#order_number' do
    it 'should return the order number' do
      response = FulfilmentResponse.new(200, {'order_number' => 'abc'})
      response.order_number.should eq('abc')
    end

    it 'should return blank if order number is missing' do
      response = FulfilmentResponse.new(200, {})
      response.order_number.should eq('')
    end
  end

  describe '#orders' do
    it 'should return a list of the oracle orders for this client order number' do
      response = FulfilmentResponse.new(200, {'order_number' => 'abc', 'orders' => [{'tracking_status' => TS_SHIPPED}, {'tracking_status' => TS_BACKORDERED}]})
      response.orders.count.should be(2)
      response.orders[0].tracking_status.should eq(TS_SHIPPED)
      response.orders[1].tracking_status.should eq(TS_BACKORDERED)
    end

    it 'should return an empty list if orders are missing' do
      response = FulfilmentResponse.new(200, {'order_number' => 'abc'})
      response.orders.empty?.should be_true
    end
  end

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
      response.error_message.should == 'Sorry, we’ve just had a technical mishap. Please try again in a few minutes.'
    end

    it 'should return nil if no error occurred' do
      response = FulfilmentResponse.new(200, {'tracking_status' => TS_PROGRESS})
      response.error_message.should be_nil
    end
  end

  describe '#error_heading' do
    it 'should return generic error message if 503 error occurred' do
      response = FulfilmentResponse.new(503, 'this could be anything')
      response.error_heading.should == 'Something didn’t go as planned.'
    end

    it 'should return nil if no error occurred' do
      response = FulfilmentResponse.new(200, {'tracking_status' => TS_PROGRESS})
      response.error_heading.should be_nil
    end
  end

end
