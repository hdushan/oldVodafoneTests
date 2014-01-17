require_relative '../../lib/fulfilment_service_provider_client.rb'
require_relative 'pact_helper.rb'
require_relative '../test_helper'
describe FulfilmentServiceProviderClient, :pact => true do
  let(:mega_menu_client) { mega_menu_mock }
  let(:fulfilment_client) { FulfilmentServiceProviderClient.new }
  let(:app) { App.new(mega_menu_client, fulfilment_client) }

  before do
    FulfilmentServiceProviderClient.base_uri 'localhost:1234'
  end

  describe 'get_order_status for non existing order id' do
    let(:response_body) { { 'response_status' => 404, 'error' => { 'error' => 'ORDER_NOT_FOUND'} } }

    before do
      fulfilment_service_provider
      .given("order with number 123 doesn't exist")
      .upon_receiving('a request for order status')
      .with( method: :get, path: '/order/123' )
      .will_respond_with(
        status: 404,
        headers: { 'Content-Type' => 'application/json;charset=utf-8' },
        body: response_body
      )
    end

    it "returns a order status" do
      #TODO This should return 'error' => 'ORDER_NOT_FOUND'
      expect(FulfilmentServiceProviderClient.new.get_order_status('123')).to eq({status: 404, 'error' => 'error', body: response_body})
    end

  end

  describe 'get_order_status for existing order id' do

    let(:response_body) {
      {
        'date_of_birth'     => '2013-07-31',
        'status'            => 'Complete',
        'email'             => 'user@example.com'
      }
    }

    before do
      fulfilment_service_provider
      .given('order with number 456 exists and completed')
      .upon_receiving('a request for order status')
      .with( method: :get, path: '/order/456' )
      .will_respond_with(
        status: 200,
        headers: { 'Content-Type' => 'application/json;charset=utf-8' },
        body: response_body
      )
    end

    it 'returns a order status' do
      expect(FulfilmentServiceProviderClient.new.get_order_status('456')).to eq({ status: 200, body: response_body })
    end

  end

  describe 'get_order_status with empty order id' do

    it 'returns a 400 error' do
      expect(FulfilmentServiceProviderClient.new.get_order_status('')).to eq({ status: 400, 'error' => 'ORDER_ID_EMPTY' })
    end
  end

  describe 'get_order_status exception handling' do
    let(:unparseable_response_body) {
      'Whoops, this is not JSON'
    }

    before do
      fulfilment_service_provider
      .given('an unexpected error in fusion')
      .upon_receiving('a request for order status')
      .with( method: :get, path: '/order/999' )
      .will_respond_with(
          status: 200,
          headers: { 'Content-Type' => 'application/json;charset=utf-8' },
          body: unparseable_response_body
      )
    end

    it 'reports the exception message' do
      expect(FulfilmentServiceProviderClient.new.get_order_status('999')).to eq(
        { status: 500,
          'error' => 'INTERNAL_ERROR', message: "757: unexpected token at 'Whoops, this is not JSON'" })
    end
  end

end