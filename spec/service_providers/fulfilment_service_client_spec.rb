require_relative '../../lib/fulfilment_service_provider_client.rb'
require_relative 'pact_helper.rb'

describe FulfilmentServiceProviderClient, :pact => true do

  before do
    # Configure your client to point to the stub service on localhost using the port you have specified
    FulfilmentServiceProviderClient.base_uri 'localhost:1234'
  end

  describe "get_order_status" do
    before do
      fulfilment_service_provider
      .given("order with number 123 don't exists")
      .upon_receiving("a request for orderd status")
      .with( method: :get, path: '/order/123' )
      .will_respond_with(
        status: 404,
        headers: { 'Content-Type' => 'application/json;charset=utf-8' },
        body: { :error => "ORDER_NOT_FOUND" }
      )
    end

    it "returns a order status" do
      expect(FulfilmentServiceProviderClient.new.get_order_status(123)).to eq("ORDER_NOT_FOUND")
    end

  end

end