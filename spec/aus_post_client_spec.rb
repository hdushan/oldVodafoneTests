require 'spec_helper'
require 'webmock/rspec'

describe AusPostClient do

  before :each do
    AusPostClient.base_uri 'https://devcentre.auspost.com.au'
    AusPostClient.basic_auth 'anonymous@auspost.com.au', 'password'
  end

  let(:client) { AusPostClient.new() }

  context 'when the request is valid' do
    context 'and international is returned' do
      let(:successful_response1) { File.read('spec/fixtures/auspost_success_international.json') }

      it 'should return data from the auspost' do
        stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.json?q=CZ299999784AU")
          .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
          .to_return(:status => 200, :body => successful_response1,
                     :headers => {"Content-Type" => "application/json;version=1\r\n"})

        response = client.track('CZ299999784AU')

        expect(response.international?).to be_true
      end
    end

    context 'and domestic events are returned' do
      let(:successful_response2) { File.read('spec/fixtures/auspost_success_domestic.json') }

      it 'should return data from the auspost' do
        stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.json?q=12345")
          .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
          .to_return(:status => 200, :body => successful_response2,
                     :headers => {"Content-Type" => "application/json;version=1\r\n"})

        response = client.track('12345')

        expect(response.international?).to be_false
        expect(response.status).to eq('Delivered')
        expect(response.events.map { |event| event['description'] }).to eq(['Delivered','Delivered','Delivered'])
        expect(response.events.map { |event| event['location'] }).to eq(["224952 work centre","224952 work centre","PROP - PROPERTY DEVELOPMENTS"])
      end
    end
  end

  context 'when authentication is not valid' do
    it 'should return unauthorised' do
      stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.json?q=CZ299999784AU")
          .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
          .to_return(:status => 401, :body => 'This request requires HTTP authentication (Bad credentials)',
                     :headers => {"Content-Type" => "text/html;charset=utf-8"})

      response = client.track('CZ299999784AU')
      expect(response.has_error?).to be_true
      expect(response.error_message).to match /Failed to get data from AusPost/
    end
  end

  context 'when tracking id is not valid' do
    let(:invalid_id_response) { File.read('spec/fixtures/auspost_invalid_id.json') }

    it 'should return 404' do
      stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.json?q=123")
            .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
            .to_return(:status => 200, :body => invalid_id_response,
                       :headers => {"Content-Type" => "application/json;version=1\r\n"})

      response = client.track('123')
      expect(response.has_error?).to be_true
      expect(response.error_message).to match /Invalid tracking ID/
    end
  end

  context 'when tracking id is not valid but AUSPost does not tell us' do

    it 'should return 500' do
      stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.json?q=CZ299991784AU")
                    .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
                    .to_return(:status => 503,
                               :headers => {"Content-Type" => "text/json"})

      response = client.track('CZ299991784AU')
      expect(response.has_error?).to be_true
      expect(response.error_message).to match /AusPost Service is not Unavailable/
    end

  end
end