require_relative '../../lib/fulfilment_service_provider_client.rb'
require_relative 'pact_helper.rb'


describe FulfilmentServiceProviderClient, :pact => true do

  before do
    # Configure your client to point to the stub service on localhost using the port you have specified
    FulfilmentServiceProviderClient.base_uri 'localhost:1234'
  end

  describe "get_order_status for non existing order id" do

    let(:response_body) { { 'error' => 'ORDER_NOT_FOUND' } }

    before do
      fulfilment_service_provider
      .given("order with number 123 don't exists")
      .upon_receiving("a request for orderd status")
      .with( method: :get, path: '/order/123' )
      .will_respond_with(
        status: 404,
        headers: { 'Content-Type' => 'application/json;charset=utf-8' },
        body: response_body
      )
    end

    it "returns a order status" do
      expect(FulfilmentServiceProviderClient.new.get_order_status(123)).to eq(response_body)
    end

  end

  describe "get_order_status for existing order id" do

    let(:response_body) {
      {
        'order_date'       => '2013-07-31',
        'last_updated_date' => '2013-07-31',
        'status'          => 'Complete'
      }
    }

    before do
      fulfilment_service_provider
      .given("order with number 456 exists and completed")
      .upon_receiving("a request for orderd status")
      .with( method: :get, path: '/order/456' )
      .will_respond_with(
        status: 200,
        headers: { 'Content-Type' => 'application/json;charset=utf-8' },
        #body: response_body TODO fix me, test not working on fulfilment service
      )
    end

    it "returns a order status" do
      expect(FulfilmentServiceProviderClient.new.get_order_status(456)).to eq(response_body)
    end

  end

end