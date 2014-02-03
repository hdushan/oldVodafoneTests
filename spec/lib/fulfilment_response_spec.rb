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

  describe '#status' do
    it 'should map the status to a user friendly value' do
      response = FulfilmentResponse.new(200, {"tracking_status" => "IN PROGRESS"})
      response.status.should == 'Your order is in progress'
    end
  end
end