require 'spec_helper'

describe "Track & Trace App" do

  it "should respond to GET" do
    get '/tnt'
    last_response.should be_ok
    last_response.should match /Tracking number/i
  end

  it 'should response with timeout error' do
    FulfilmentServiceProviderClient.any_instance.stub(:get_order_status).with('TIMEOUT') do |arg|
      { 'error' => 'FUSION_TIMEOUT'}
    end

    post '/track', {tracking_id: 'TIMEOUT'}

    last_response.body.should match /system timeout/i
  end
end