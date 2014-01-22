require 'spec_helper'

describe 'order_status.haml' do
  let(:fulfilment_client) { double(FulfilmentServiceProviderClient) }
  let(:mega_menu_client) { mega_menu_mock }
  let(:app) { App.new(mega_menu_client, fulfilment_client) }

  subject { last_response }

  context 'invalid order id' do
    before { get '/tnt/abc' }

    its(:status) { should eq 404 }
    its(:body) { should have_tag(:p, text: 'Order not found') }
  end

  context 'valid order id' do
  end
end
