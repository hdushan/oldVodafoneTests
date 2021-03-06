require 'spec_helper'
require 'fulfilment_client'

include StatusStrings

describe "Track & Trace App" do

  let(:fulfilment_client) { double(FulfilmentClient) }

  let(:mega_menu_client) { double(MegaMenuAPIClient, :get_menu => { 'desktop' => MegaMenuAPIClient.empty_response,
                                                                    'mobile' => MegaMenuAPIClient.empty_response}) }

  let(:app) do
    App.new(%w{fancy.hostname.com}, mega_menu_client, fulfilment_client)
  end

  subject { last_response }

  describe 'GET /tracking' do
    before { get '/tracking' }

    it { should be_ok }
    it { should match /tracking number/i }
  end

  describe 'POST /tracking' do
    context 'when no referrer provided' do
      before do
        post '/tracking', tracking_id: 'abc'
      end

      its(:status) { should eq 400 }
    end

    context 'when referrer is specified'  do
      before do
        header 'Referer', 'https://fancy.hostname.com/tnt'
        post '/tracking', tracking_id: 'abc'
      end

      its(:status) { should eq 302 }
      its(:location) { should end_with '/tracking/abc' }
    end
  end

  describe 'fix broken mega menu mobile footer' do
    before { get '/cs/static/img/mobile/image.png' }

    it { should be_redirect }
    its(:location) { should eq('http://www.vodafone.com.au/cs/static/img/mobile/image.png') }
  end

  describe 'GET /tracking/trackingtermsconditions' do
    before { get '/tracking/trackingtermsconditions'}

    its(:status) { should be 200 }
    its(:body) { should match /terms and conditions/i}
  end

  describe 'GET /tracking/:id' do
    before do
      fulfilment_client.stub(:get_order_details).with('abc', '127.0.0.1') do |arg|
        fulfilment_response
      end

      get '/tracking/abc'
    end

    context 'when Fulfilment Service is available' do
      context 'with a missing id' do
        let(:fulfilment_response) { FulfilmentResponse.new(404, "We don't care") }

        its(:status) { should eq 404 }
        its(:body) { should have_tag('div.error-msg') }
        its(:body) { should match(/entered your tracking number exactly/) }
        its(:body) { should have_tag("#tracking_id[value='abc']") }
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
      its(:body) { should have_tag('div.error-msg') }
      its(:body) { should match(/Something didn.t go as planned/) }
      its(:body) { should match(/technical mishap/) }
    end
  end

  describe 'GET /shared_content/flush_cache' do

    before { get '/shared_content/flush_cache' }

    it { should be_ok }
    its(:body) { should eq 'Shared Content Flushed OK' }

  end

  describe 'creating an App without any constructor arguments' do
    it 'should work' do
      expect { App.new }.to_not raise_error, <<-DOC
sinatra-assetpack expects to create an App without any constructor arguments
if it can't do that, then it'll fail to precompile assets ONLY in production
mode. I've put this test in place so we can have an early warning. Make sure
App can be constructed without any arguments. It's crap, but necessary.
DOC
    end
  end
end
