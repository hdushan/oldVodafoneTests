require 'spec_helper'
require 'fulfilment_client'

include StatusStrings

describe "Track & Trace App" do

  let(:fulfilment_client) { double(FulfilmentClient) }

  let(:mega_menu_client) { double(MegaMenuAPIClient, :get_menu => { 'desktop' => MegaMenuAPIClient.empty_response,
                                                                    'mobile' => MegaMenuAPIClient.empty_response}) }

  let(:app) { App.new(mega_menu_client, fulfilment_client) }

  subject { last_response }

  describe 'GET /tnt' do
    before { get '/tnt' }

    it { should be_ok }
    it { should match /tracking number/i }
  end

  describe 'POST /tnt' do
    before { post '/tnt', tracking_id: 'abc' }

    its(:status) { should eq 302 }
    its(:location) { should end_with '/tnt/abc' }
  end

  describe 'fix broken mega menu mobile footer' do
    before { get '/cs/static/img/mobile/image.png' }

    it { should be_redirect }
    its(:location) { should eq('http://www.vodafone.com.au/cs/static/img/mobile/image.png') }
  end

  describe 'GET /tnt/trackingtermsconditions' do
    before { get '/tnt/trackingtermsconditions'}

    its(:status) { should be 200 }
    its(:body) { should match /terms and conditions/i}
  end

  describe 'GET /tnt/:id' do
    before do
      fulfilment_client.stub(:get_order_details).with('abc', '127.0.0.1') do |arg|
        fulfilment_response
      end

      get '/tnt/abc'
    end

    context 'when Fulfilment Service is available' do
      context 'with a missing id' do
        let(:fulfilment_response) { FulfilmentResponse.new(404, "We don't care") }

        its(:status) { should eq 404 }
        its(:body) { should have_tag(:span, text: 'That order ID was not found. Please, check that you typed it correctly.') }
      end

      context 'with a valid id' do
        let(:fulfilment_response) { FulfilmentResponse.new(200, {'orders' => [{'tracking_status' => TS_CANCELLED}]}) }

        its(:status) { should eq 200 }
        its(:body) { should match /cancelled/ }
      end
    end

    context 'when Fulfilment Service is not available' do
      let(:fulfilment_response) { raise 'Faraday::Error::ConnectionFailed - Connection refused - connect(2)' }

      its(:status) { should eq 500 }
      its(:body) { should have_tag(:span, text: 'There was a problem retrieving your order.') }
    end
  end
end
