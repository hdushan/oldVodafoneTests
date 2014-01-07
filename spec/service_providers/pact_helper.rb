require 'pact/consumer/rspec'
WebMock.disable_net_connect!(:allow => "localhost:1234")

Pact.service_consumer 'Track and trace service' do
  has_pact_with 'Fulfilment service' do
    mock_service :fulfilment_service_provider do
      port 1234
    end
  end
end