require 'spec_helper'
require_relative 'pact_helper'

include StatusStrings

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
  let(:fulfilment_client) { FulfilmentClient.new(PutsLogger.new, 'http://localhost:1234/v1') }
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
      response = fulfilment_client.get_order_details('VF123NOTFOUND', '1.2.3.4')

      expect(response).to have_error
      expect(response.error_message).to eq('That order ID was not found. Please, check that you typed it correctly.')
    end
  end

  describe 'get_order_details for existing order id' do
    let(:tracking_info) { {} }
    let(:response_body) {
      {
        'tracking_status' => TS_SHIPPED,
        'ordered_date' => '2013-07-31',
        'consignment_number' => 'cn123',
        'items' => [
          {
            'description' => 'phone'
          },
          {
            'description' => 'sim'
          }
        ],
        'tracking' => tracking_info
      }
    }

    context 'no error in tracking information' do
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
        response = fulfilment_client.get_order_details('VF456', '1.2.3.4')

        expect(response).to_not have_error
        expect(response.status_message).to match /shipped/
      end
    end

    context 'has business exception in tracking information' do
      let(:tracking_info) { {'business_exception' => 'Invalid tracking ID'} }

      before do
        stub_root_resource fulfilment_service_provider, 'a business exception in tracking info'

        fulfilment_service_provider
        .given('a business exception in tracking info')
        .upon_receiving('a request for order status')
        .with(method: :get, path: '/v1/order/VF789')
        .will_respond_with(
          status: 200,
          headers: {'Content-Type' => 'application/hal+json'},
          body: response_body
        )
      end

      it 'should return an order status with error in tracking information' do
        response = fulfilment_client.get_order_details('VF789', '1.2.3.4')

        expect(response).to_not have_error
        expect(response.auspost_business_exception?).to be_true
        expect(response.tracking).to eql(tracking_info)
      end
    end

    context 'has error in tracking information' do
      let(:tracking_info) { {'error' => 'Request to AusPost timed out'} }

      before do
        stub_root_resource fulfilment_service_provider, 'an error in getting tracking info'

        fulfilment_service_provider
          .given('an error in getting tracking info')
          .upon_receiving('a request for order status')
          .with(method: :get, path: '/v1/order/VF789')
          .will_respond_with(
            status: 200,
            headers: {'Content-Type' => 'application/hal+json'},
            body: response_body
          )
      end

      it 'should return an order status with error in tracking information' do
        response = fulfilment_client.get_order_details('VF789', '1.2.3.4')

        expect(response).to_not have_error
        expect(response.auspost_error?).to be_true
        expect(response.tracking).to eql(tracking_info)
      end
    end
  end

  describe 'get_order_details for invalid order id' do
    before do
      stub_root_resource fulfilment_service_provider, 'invalid order id'

      fulfilment_service_provider
        .given('invalid order id')
        .upon_receiving('a request for order status')
        .with(method: :get, path: '/v1/order/invalid')
        .will_respond_with(status: 403)
    end

    it 'should return an order status' do
      response = fulfilment_client.get_order_details('invalid', '1.2.3.4')

      expect(response).to have_error
      expect(response.error_message).to match /invalid order id/i
    end
  end

  describe 'when fusion is not available' do
    before do
      stub_root_resource fulfilment_service_provider, 'an unexpected error in fusion'

      fulfilment_service_provider
        .given('an unexpected error in fusion')
        .upon_receiving('a request for order status')
        .with(method: :get, path: '/v1/order/VF503')
        .will_respond_with(status: 503)
    end

    it 'should return a generic error message' do
      response = fulfilment_client.get_order_details('VF503', '1.2.3.4')

      expect(response).to have_error
      expect(response.error_message).to match /Service Unavailable/
    end
  end

  describe 'when fulfilment is broken' do
    before do
      stub_root_resource fulfilment_service_provider, 'fulfilment is broken'

      fulfilment_service_provider
        .given('fulfilment is broken')
        .upon_receiving('a request for order status')
        .with(method: :get, path: '/v1/order/VF503')
        .will_respond_with(status: 500)
    end

    it 'should return a generic error message' do
      response = fulfilment_client.get_order_details('VF503', '1.2.3.4')

      expect(response).to have_error
      expect(response.error_message).to eq 'There was a problem retrieving your order.'
    end
  end
end
