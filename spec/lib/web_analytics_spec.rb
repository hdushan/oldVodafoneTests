require 'spec_helper'


describe WebAnalytics do
  let(:fulfilment_response) { double(FulfilmentResponse.class) }

  it 'should always return error on error_json' do

    expect(WebAnalytics.new('VF123', nil).error_json).to eq(['tnt', { 'trackingID' => 'VF123', 'orderStatus' => 'error'}])
  end

  context 'when fulfilment_response has error' do
    it 'should return error status' do
      fulfilment_response.should_receive(:has_error?).and_return(true)
      fulfilment_response.should_receive(:orders).and_return([])

      result = WebAnalytics.new('VF123', fulfilment_response).to_json

      expect(result).to eq(['tnt', { 'trackingID' => 'VF123', 'orderStatus' => 'error'}])
    end
  end

  context 'when there is no error' do
    let(:fulfilment_response) { FulfilmentResponse.new( 200, response_body)}

    context 'when there is only one status' do
      let(:response_body) do
        {'order_number' => 'VF123',
         'orders' => [{'tracking_status' => TS_SHIPPED}]}
      end

      it 'should return statuses separated by semicolon' do
        result = WebAnalytics.new('VF123', fulfilment_response).to_json

        expect(result).to eq(['tnt', { 'trackingID' => 'VF123', 'orderStatus' => 'shipped'}])
      end
    end
    context 'when fulfilment response does not have shipping information' do
      let(:response_body) do
        {'order_number' => 'VF123',
         'orders' => [{'tracking_status' => TS_SHIPPED},
                      {'tracking_status' => TS_BACKORDERED}]}
      end

      it 'should return statuses separated by semicolon' do
        result = WebAnalytics.new('VF123', fulfilment_response).to_json

        expect(result).to eq(['tnt', { 'trackingID' => 'VF123', 'orderStatus' => 'shipped,backordered'}])
      end
    end

    context 'when fulfilment response has tracking information' do
      let(:response_body) do
        {'order_number' => 'VF123',
         'orders' => [{'tracking_status' => TS_SHIPPED, 'tracking' => {'status' => 'Delivered'}},
                      {'tracking_status' => TS_SHIPPED, 'tracking' => {'status' => 'In Transit'}}]}
      end


      it 'should return tracking statuses separated from response statuses with colon' do
        result = WebAnalytics.new('VF123', fulfilment_response).to_json

          expect(result).to eq(['tnt', { 'trackingID' => 'VF123',
                                         'orderStatus' => 'shipped,shipped',
                                         'auspostStatus' => 'delivered,in_transit'}])
      end
    end
  end
end

