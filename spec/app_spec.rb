require 'spec_helper'

describe "Track & Trace App" do

  it "should respond to GET" do
    get '/tnt'
    last_response.should be_ok
    last_response.should match /Tracking number/i
  end


  describe "POST '/track'" do
    let(:fulfilment_response) { {} }
    let(:tracking_id) { 'vf123' }
    before do
      FulfilmentServiceProviderClient.any_instance.stub(:get_order_status).with(tracking_id) do |arg|
        fulfilment_response
      end
    end

    subject do
      post '/track', {tracking_id: tracking_id}
      last_response
    end

    context 'timeout error' do
      let(:fulfilment_response) { { 'error' => 'FUSION_TIMEOUT'} }
      let(:tracking_id) { 'TIMEOUT' }

      its(:body) { should match /system timeout/i }
    end

    context 'no error' do
      context 'fulfilmeet response with email or date of birth' do
        let(:fulfilment_response) { { 'email' => 'abc@example.com'} }

        it 'should have authentication url' do
          subject.body.should include('Click here to see your order details')
          subject.body.should include("/auth?order_id=#{tracking_id}&authType=email")
        end
      end

      context 'fulfilmeet response without email or date of birth' do
        let(:fulfilment_response) { { 'email' => nil, 'date_of_birth' => nil} }

        it 'should not have authentication url' do
          subject.body.should_not include('Click here to see your order details')
          subject.body.should_not include("/auth?order_id")
        end
      end
    end

  end

end
