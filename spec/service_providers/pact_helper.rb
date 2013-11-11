require 'pact/consumer/rspec'

Pact.service_consumer "Track and trace service" do
  has_pact_with "Fulfilment service" do
    mock_service :fulfilment_service_provider do
      port 1234
    end
  end
end