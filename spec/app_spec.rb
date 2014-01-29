require 'spec_helper'
require 'fulfilment_client'

describe "Track & Trace App" do
  let(:fulfilment_client) { double(FulfilmentClient) }

  let(:mega_menu_client) do
    mega_menu_client = double(MegaMenuAPIClient)
    allow(mega_menu_client).to receive(:get_menu).and_return(MegaMenuAPIClient.empty_response)
    mega_menu_client
  end

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

  describe 'GET /tnt/:id' do
    before do
      fulfilment_client.stub(:get_order_details).with('abc') do |arg|
        fulfilment_response
      end

      get '/tnt/abc'
    end

    context 'with a missing id' do
      let(:fulfilment_response) { FulfilmentResponse.new(404, "We don't care") }

      its(:status) { should eq 404 }
      its(:body) { should have_tag(:p, text: 'That order ID was not found. Please, check that you typed it correctly.') }
    end

    context 'with a valid id' do
      let(:fulfilment_response) { FulfilmentResponse.new(200, '{ "status": "TERMINATED"}') }

      its(:status) { should eq 200 }
      its(:body) { should match /terminated/ }
    end
  end

end
