require 'fulfilment_client'
require_relative '../test_helper'
require_relative 'pact_helper'

describe FulfilmentClient, :pact => true do
  let(:mega_menu_client) { mega_menu_mock }
  let(:fulfilment_client) { FulfilmentClient.new }
  let(:app) { App.new(mega_menu_client, fulfilment_client) }

  before do
    FulfilmentClient.base_uri 'localhost:1234'
  end

  describe 'get_order_status for non existing order id' do
    let(:response_body) { {'error' => 'ORDER_NOT_FOUND'} }

    before do
      fulfilment_service_provider
      .given("order with number 123 doesn't exist")
      .upon_receiving('a request for order status')
      .with(method: :get, path: '/order/123')
      .will_respond_with(
          status: 404,
          headers: {'Content-Type' => 'application/json;charset=utf-8'},
          body: response_body
      )
    end

    it "returns a order status" do
      expect(FulfilmentClient.new.get_order_status('123')).to eq({status: 404, 'error' => 'ORDER_NOT_FOUND'})
    end

  end

  describe 'get_order_status for existing order id' do

    let(:response_body) {
      {
          'status' => 'Complete',
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

    it 'returns a order status' do
      expect(FulfilmentClient.new.get_order_status('456')).to eq({status: 200, body: response_body})
    end

  end

  describe 'get_order_status with empty order id' do

    it 'returns a 400 error' do
      expect(FulfilmentClient.new.get_order_status('')).to eq({status: 400, 'error' => 'ORDER_ID_EMPTY'})
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
      .with(method: :get, path: '/order/999')
      .will_respond_with(
          status: 200,
          headers: {'Content-Type' => 'application/json;charset=utf-8'},
          body: unparseable_response_body
      )
    end

    it 'reports the exception message' do
      expect(FulfilmentClient.new.get_order_status('999')).to eq(
                                                                                 {status: 500,
                                                                                  'error' => 'INTERNAL_ERROR', message: "757: unexpected token at 'Whoops, this is not JSON'"})
    end
  end

end
