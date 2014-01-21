require 'spec_helper'
require 'webmock/rspec'

describe AusPostClient do
  let(:client) { AusPostClient.new('anonymous@auspost.com.au', 'password') }

  context 'when the request is valid' do
    context 'and international is returned' do
      let(:successful_response1) { File.read('spec/fixtures/auspost_success_international.xml') }

      it 'should return data from the auspost' do
        stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.xml?q=CZ299999784AU")
          .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
          .to_return(:status => 200, :body => successful_response1,
                     :headers => {"Content-Type" => "application/xml;version=1\r\n"})

        response = client.track('CZ299999784AU')

        expect(response['international']).to be_true
      end
    end

    context 'and domestic events are returned' do
      let(:successful_response2) { File.read('spec/fixtures/auspost_success_domestic.xml') }

      it 'should return xml from the auspost' do
        stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.xml?q=12345")
          .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
          .to_return(:status => 200, :body => successful_response2,
                     :headers => {"Content-Type" => "application/xml;version=1\r\n"})

        response = client.track('12345')

        expect(response['international']).to be_false
        expect(response['status']).to eq('Delivered')
        expect(response['events'].map { |event| event['description'] }).to eq(['Delivered','Delivered','Delivered'])
        expect(response['events'].map { |event| event['location'] }).to eq(["224952 work centre","224952 work centre","PROP - PROPERTY DEVELOPMENTS"])
      end
    end
  end

  context 'when authentication is not valid' do
    it 'should return 401' do
      stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.xml?q=CZ299999784AU")
          .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
          .to_return(:status => 401, :body => 'This request requires HTTP authentication (Bad credentials)',
                     :headers => {"Content-Type" => "text/html;charset=utf-8"})

      expect {
        client.track('CZ299999784AU')
      }.to raise_error /This request requires HTTP authentication/
    end
  end

  context 'when tracking id is not valid' do
    let(:invalid_id_response) { File.read('spec/fixtures/auspost_invalid_id.xml') }

    it 'should return 404' do
      stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.xml?q=123")
            .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
            .to_return(:status => 200, :body => invalid_id_response,
                       :headers => {"Content-Type" => "application/xml;version=1\r\n"})
      expect {
        client.track('123')
      }.to raise_error /Invalid tracking ID/
    end
  end

  context 'when tracking id is not valid but AUSPost does not tell us' do

    it 'should return 500' do
      stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.xml?q=CZ299991784AU")
                    .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
                    .to_return(:status => 503,
                               :headers => {"Content-Type" => "text/xml"})

      expect {
        client.track('CZ299991784AU')
      }.to raise_error /Service Unavailable or Consignment ID is not valid/
    end

  end
end