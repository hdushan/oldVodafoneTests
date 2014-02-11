require 'spec_helper'
require 'fulfilment_client'

describe "Track & Trace App" do
  let(:fulfilment_client) { double(FulfilmentClient) }

  let(:mega_menu_client) { double(MegaMenuAPIClient, :get_menu => MegaMenuAPIClient.empty_response) }

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
        its(:body) { should have_tag(:p, text: 'That order ID was not found. Please, check that you typed it correctly.') }
      end

      context 'with a valid id' do
        let(:fulfilment_response) { FulfilmentResponse.new(200, {'tracking_status' => 'CANCELLED'}) }

        its(:status) { should eq 200 }
        its(:body) { should match /cancelled/ }
      end
    end

    context 'when Fulfilment Service is not availablle' do
      let(:fulfilment_response) { raise 'Faraday::Error::ConnectionFailed - Connection refused - connect(2)' }

      its(:status) { should eq 500 }
      its(:body) { should have_tag(:p, text: 'There was a problem retrieving your order.') }
    end
  end

  describe 'GET /tnt/:id?channel=:channel' do
    context 'the user is on desktop' do

      it 'should use the mobile mega menu if mobile channel is requested' do
        get '/tnt/abc?channel=mobile', {}, { "HTTP_USER_AGENT" => "Desktop" }
        expect(mega_menu_client).to have_received(:get_menu).with(true)
      end

      it 'should use the desktop mega menu if desktop channel is requested' do
        get '/tnt/abc?channel=desktop', {}, { "HTTP_USER_AGENT" => "Desktop" }
        expect(mega_menu_client).to have_received(:get_menu).with(false)
      end

      it 'should use the desktop mega menu if no channel is requested' do
        get '/tnt/abc', {}, { "HTTP_USER_AGENT" => "Desktop" }
        expect(mega_menu_client).to have_received(:get_menu).with(false)
      end

    end

    context 'the user is on mobile' do

      it 'should use the mobile mega menu if mobile channel is requested' do
        get '/tnt/abc?channel=mobile', {}, { "HTTP_USER_AGENT" => "Mobile" }
        expect(mega_menu_client).to have_received(:get_menu).with(true)
      end

      it 'should use the desktop mega menu if desktop channel is requested' do
        get '/tnt/abc?channel=desktop', {}, { "HTTP_USER_AGENT" => "Mobile" }
        expect(mega_menu_client).to have_received(:get_menu).with(false)
      end

      it 'should use the mobile mega menu if no channel is requested' do
        get '/tnt/abc', {}, { "HTTP_USER_AGENT" => "Mobile" }
        expect(mega_menu_client).to have_received(:get_menu).with(true)
      end

    end

  end
end
