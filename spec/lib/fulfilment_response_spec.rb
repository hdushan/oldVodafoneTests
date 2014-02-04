require 'spec_helper'

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
      response = FulfilmentResponse.new(200, {"tracking_status" => "IN PROGRESS"})
      response.error_message.should be_nil
    end
  end

  describe '#status_message' do
    it 'should map the status to a user friendly message' do
      response = FulfilmentResponse.new(200, {"tracking_status" => "IN PROGRESS"})
      response.status_message.should == 'Your order is in progress'
    end
  end

  describe '#status_heading' do
    it 'should map the status to a user friendly header' do
      response = FulfilmentResponse.new(200, {"tracking_status" => "IN PROGRESS"})
      response.status_heading.should == 'In Progress'
    end
  end

  describe '#items' do
    it 'should map the shipping line items if present' do
      response = FulfilmentResponse.new(200, {"tracking_status" => "IN PROGRESS", "items" => [
          {"description" => "iPhone", "item_quantity" => "1"},
          {"description" => "sim", "item_quantity" => "2"}
      ]})
      response.items.first.should == {item_quantity: "1", description: "iPhone"}
      response.items.last.should == {item_quantity: "2", description: "sim"}
    end

    it 'should return empty array if there are no shipping line items' do
      response = FulfilmentResponse.new(200, {"tracking_status" => "IN PROGRESS"})
      response.items.should == []
    end
  end
end