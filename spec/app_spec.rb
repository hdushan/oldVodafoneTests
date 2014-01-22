require 'spec_helper'

describe "Track & Trace App" do
  let(:fulfilment_client) { double(FulfilmentServiceProviderClient) }

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
      fulfilment_client.stub(:get_order_status).with('abc') do |arg|
        fulfilment_response
      end

      get '/tnt/abc'
    end

    context 'with a missing id' do
      let(:fulfilment_response) { { status: 404, 'error' => 'ORDER_NOT_FOUND'} }

      its(:status) { should eq 404 }
      its(:body) { should have_tag(:p, text: 'Order not found.') }
    end

    context 'with a valid id' do
      let(:fulfilment_response) { { status: 200, body: { yes: 'no' } } }

      its(:status) { should eq 200 }
      its(:body) { should match 'yes: no' }
    end
  end

end
