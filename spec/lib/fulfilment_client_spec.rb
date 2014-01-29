require 'hyperclient'
require 'rspec/mocks'
require 'spec_helper'

describe FulfilmentClient do
  let(:fulfilment_client) { FulfilmentClient.new }

  context 'when order id is empty' do
    it 'should raise an "empty" error' do
      expect { fulfilment_client.get_order_details('') }.to raise_error /empty/
    end
  end

  context 'when order id is not empty' do
    context 'and response has an error' do
      it 'should return error' do
        fulfilment_client.stub(:request_order_status) { OpenStruct.new(status: 404,
                                                                   body: { "error" => "ORDER_NOT_FOUND"})}

        response = fulfilment_client.get_order_details('1234')

        expect(response.has_error?).to eq(true)
        expect(response.error_message).to eq('That order ID was not found. Please, check that you typed it correctly.')
      end
    end

    context 'and response has a valid data' do
      it 'should return the data from the response' do
        fulfilment_client.stub(:request_order_status) { OpenStruct.new(status: 200,
                                                                   body: { "status" => "BOOKED"})}

        response = fulfilment_client.get_order_details('1234')

        expect(response.has_error?).to eq(false)
        expect(response.status).to match(/booked/)
      end
    end

  end
end