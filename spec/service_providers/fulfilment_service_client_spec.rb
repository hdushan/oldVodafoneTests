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

    before do
      fulfilment_service_provider
      .given("order with number 123 doesn't exist")
      .upon_receiving('a request for order status')
      .with(method: :get, path: '/order/123')
      .will_respond_with(
          status: 404,
          headers: {'Content-Type' => 'application/json;charset=utf-8'},
          body: "{}"
      )
    end

    it 'should have an error message' do
      response = FulfilmentServiceProviderClient.new.get_order_details('123')

      expect(response.has_error?).to be_true
      expect(response.error_message).to eq('That order ID was not found. Please, check that you typed it correctly.')
    end

  end

  describe 'get_order_status for existing order id' do

    let(:response_body) {
      {
          'status' => 'BOOKED',
          'ordered_date' => '2013-07-31',
          'consignment_number' => 'cn123',
          'items' => [
              {
                  'description' => 'phone'
              },
              {
                  'description' => 'sim'
              }
          ]


      }
    }

    before do
      fulfilment_service_provider
      .given('order with number 456 exists and completed')
      .upon_receiving('a request for order status')
      .with(method: :get, path: '/order/456')
      .will_respond_with(
          status: 200,
          headers: {'Content-Type' => 'application/json;charset=utf-8'},
          body: response_body
      )
    end

    it 'should return an order status' do
      response = FulfilmentServiceProviderClient.new.get_order_details('456')
      expect(response.has_error?).to be_false
      expect(response.status).to match /booked/
    end

  end

  describe 'when fusion is not available' do
    let(:error_response_body) { 'This could be anything' }

    before do
      fulfilment_service_provider
      .given('an unexpected error in fusion')
      .upon_receiving('a request for order status')
      .with(method: :get, path: '/order/999')
      .will_respond_with(
          status: 503,
          headers: {'Content-Type' => 'application/json;charset=utf-8'},
          body: error_response_body
      )
    end

    it 'should return a generic error message' do
      response = FulfilmentServiceProviderClient.new.get_order_details('999')
      expect(response.has_error?).to be_true
      expect(response.error_message).to match /Service Unavailable/
    end
  end

end