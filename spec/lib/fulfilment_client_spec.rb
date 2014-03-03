require 'hyperclient'
require 'rspec/mocks'
require 'spec_helper'
require 'webmock'

include StatusStrings

describe FulfilmentClient do
  let(:fulfilment_client) { FulfilmentClient.new(PutsLogger.new, 'http://someserver.org') }

  context 'when order id is empty' do
    it 'should raise an "empty" error' do
      expect { fulfilment_client.get_order_details('', '1.2.3.4') }.to raise_error /empty/
    end
  end

  context 'when order id is not empty' do

    it 'should pass ip address as X-Forwarded-For http header' do
      stub_request(:get, 'http://someserver.org')
      .with(:headers => {'X-Forwarded-For' => '1.2.3.4',
        'Accept' => 'application/json',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v0.8.9'})
      .to_return(:status => 200, :body => '{"_links": {"order": { "href": "http://someserver/v1/order/{id}", "templated": true}}}',
        :headers => {"Content-Type" => "application/json;version=1\r\n"})

      stub_request(:get, "http://someserver/v1/order/1234").
        with(:headers => {'Accept' => 'application/json',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v0.8.9',
        'X-Forwarded-For' => '1.2.3.4'}).
        to_return(:status => 200, :body => {}, :headers => {})

      fulfilment_client.get_order_details('1234', '1.2.3.4')
    end

    context 'and response has an error' do
      it 'should return error' do
        fulfilment_client.stub(:request_order_status) { OpenStruct.new(status: 404,
          body: {"error" => "ORDER_NOT_FOUND"}) }

        response = fulfilment_client.get_order_details('1234', '1.2.3.4')

        expect(response.has_error?).to eq(true)
        expect(response.error_message).to eq('That order ID was not found. Please, check that you typed it correctly.')
      end
    end

    context 'and response has a valid data' do
      it 'should return the data from the response' do
        fulfilment_client.stub(:request_order_status) { OpenStruct.new(status: 200,
          body: {'orders'=>[{'tracking_status' => TS_PROGRESS}]}) }

        response = fulfilment_client.get_order_details('1234', '1.2.3.4')

        expect(response.has_error?).to eq(false)
        expect(response.orders.first.status_message).to match(/in progress/)
      end
    end

  end
end