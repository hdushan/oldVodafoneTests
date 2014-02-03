require 'fulfilment_client'
require 'pry'
require_relative '../test_helper'
require_relative 'pact_helper'

def stub_root_resource(fulfilment_service_provider, given)
  fulfilment_service_provider
  .given(given)
  .upon_receiving('a request for the root resource')
  .with(method: :get, path: '/v1')
  .will_respond_with(
      status: 200,
      headers: {'Content-Type' => 'application/hal+json'},
      body: {
          _links: {
              order: {
                  href: "#{fulfilment_service_provider.mock_service_base_url}/v1/order/{id}",
                  templated: true
              }
          }
      }
  )
end

describe FulfilmentClient, :pact => true do
  let(:mega_menu_client) { mega_menu_mock }
  let(:fulfilment_client) { FulfilmentClient.new('http://localhost:1234/v1') }
  let(:app) { App.new(mega_menu_client, fulfilment_client) }

  describe 'get_order_details for non existing order id' do
    before do
      stub_root_resource fulfilment_service_provider, "order doesn't exist"

      fulfilment_service_provider
        .given("order doesn't exist")
        .upon_receiving('a request for order status')
        .with(method: :get, path: '/v1/order/VF123NOTFOUND')
        .will_respond_with(
            status: 404,
            headers: {'Content-Type' => 'application/hal+json'}
        )
    end

    it 'should have an error message' do
      response = fulfilment_client.get_order_details('VF123NOTFOUND')

      expect(response.has_error?).to be_true
      expect(response.error_message).to eq('That order ID was not found. Please, check that you typed it correctly.')
    end
  end

  describe 'get_order_details for existing order id' do
    let(:response_body) {
      {
        'tracking_status' => 'IN PROGRESS',
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
      stub_root_resource fulfilment_service_provider, 'order exists and completed'

      fulfilment_service_provider
        .given('order exists and completed')
        .upon_receiving('a request for order status')
        .with(method: :get, path: '/v1/order/VF456')
        .will_respond_with(
          status: 200,
          headers: {'Content-Type' => 'application/hal+json'},
          body: response_body
        )
    end

    it 'should return an order status' do
      response = fulfilment_client.get_order_details('VF456')

      expect(response.has_error?).to be_false
      expect(response.status_message).to match /in progress/
    end
  end

  describe 'when fusion is not available' do

    before do
      stub_root_resource fulfilment_service_provider, 'an unexpected error in fusion'

      fulfilment_service_provider
        .given('an unexpected error in fusion')
        .upon_receiving('a request for order status')
        .with(method: :get, path: '/v1/order/VF503')
        .will_respond_with(
          status: 503,
          headers: {'Content-Type' => 'application/hal+json'}
        )
    end

    it 'should return a generic error message' do
      response = fulfilment_client.get_order_details('VF503')

      expect(response.has_error?).to be_true
      expect(response.error_message).to match /Service Unavailable/
    end
  end

end
