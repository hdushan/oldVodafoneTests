require 'spec_helper'

describe "Track & Trace App" do
  let(:fulfilment_client) { double(FulfilmentServiceProviderClient) }

  let(:mega_menu_client) do
    mega_menu_client = double(MegaMenuAPIClient)
    allow(mega_menu_client).to receive(:get_menu).and_return(MegaMenuAPIClient.empty_response)
    mega_menu_client
  end

  let(:app) { App.new(mega_menu_client, fulfilment_client) }

  it "should respond to GET" do
    get '/tnt'
    last_response.should be_ok
    last_response.should match /Tracking number/i
  end


  describe "POST '/track'" do
    let(:fulfilment_response) { {} }
    let(:tracking_id) { 'vf123' }
    before do
      fulfilment_client.stub(:get_order_status).with(tracking_id) do |arg|
        fulfilment_response
      end
    end

    subject do
      post '/track', {tracking_id: tracking_id}
      last_response
    end

    context 'invalid order id' do
      let(:fulfilment_response) { { 'error' => 'INVALID_FORMAT'} }
      let(:tracking_id) { 'INVALID' }

      its(:body) { should match /order id invalid/i }
    end

    context 'timeout error' do
      let(:fulfilment_response) { { 'error' => 'FUSION_TIMEOUT'} }
      let(:tracking_id) { 'TIMEOUT' }

      its(:body) { should match /system timeout/i }
    end

    context 'no error' do
      context 'fulfilment response with email or date of birth' do
        let(:fulfilment_response) { { 'email' => 'abc@example.com'} }

        it 'should have authentication url' do
          subject.body.should include('Click here to see your order details')
          subject.body.should include("/auth?order_id=#{tracking_id}&authType=email")
        end
      end

      context 'fulfilment response without email or date of birth' do
        let(:fulfilment_response) { { 'email' => nil, 'date_of_birth' => nil} }

        it 'should not have authentication url' do
          subject.body.should_not include('Click here to see your order details')
          subject.body.should_not include("/auth?order_id")
        end
      end
    end

  end

end
