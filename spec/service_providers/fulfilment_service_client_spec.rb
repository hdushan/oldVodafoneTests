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
      .given("order with number 123 exists")
      .upon_receiving("a request for orderd status")
      .with( method: :get, path: '/order/123' )
      .will_respond_with(
        status: 200,
        headers: { 'Content-Type' => 'application/json' },
        body: {status: 'Credit check'}
      )
    end

    it "returns a order status" do
      expect(FulfilmentServiceProviderClient.new.get_order_status).to eq("Credit check")
    end

  end

end