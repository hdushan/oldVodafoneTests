require 'spec_helper'

describe FulfilmentClient do
  let(:fulfilment_client) { FulfilmentClient.new }

  context 'when order id is empty' do
    it 'should return ORDER_ID_EMPTY' do
      response = fulfilment_client.get_order_status('')

      expect(response).to eq( { status: 400, 'error' => 'ORDER_ID_EMPTY' } )
    end
  end

  context 'when order id is not empty' do
    context 'and response has an error' do
      it 'should return error' do
        FulfilmentClient.should_receive(:get)
                                        .with('/order/1234')
                                        .and_return(OpenStruct.new(code: 404,
                                                                   body: '{ "error": "ORDER_NOT_FOUND"}'))

        response = fulfilment_client.get_order_status('1234')

        expect(response).to eq({ status: 404, 'error' => 'ORDER_NOT_FOUND'})
      end
    end

    context 'and response has a valid data' do
      it 'should return the data from the response' do
        FulfilmentClient.should_receive(:get)
                                        .with('/order/1234')
                                        .and_return(OpenStruct.new(code: 200,
                                                                   body: '{ "date_of_birth": "2013-07-31",
                                                                            "status": "Complete",
                                                                            "email": "user@example.com" }'))

        response = fulfilment_client.get_order_status('1234')

        expect(response).to eq({ status: 200, body: { 'date_of_birth'     => '2013-07-31',
                                                      'status'            => 'Complete',
                                                      'email'             => 'user@example.com' }})
      end
    end

    context 'and there was a failure' do
      it 'should return error' do
        FulfilmentClient.should_receive(:get)
                                          .with('/order/1234')
                                          .and_raise('epic failure!')

        response = fulfilment_client.get_order_status('1234')

        expect(response).to eq({ status: 500, 'error' => 'INTERNAL_ERROR', message: 'epic failure!'})
      end
    end
  end
end
