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

        expect(response[:body]["ArticleDetails"]["ProductName"]).to eq('International')
        expect(response[:body]["ArticleDetails"]["EventNotification"]).to eq('00')
        expect(response[:body]["ArticleDetails"]["EventCount"]).to eq('0')
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

        expect(response[:body]["ArticleDetails"]["Status"]).to eq('Delivered')
        expect(
            response[:body]["ArticleDetails"]["Events"]["Event"].map { |event| event["Location"] }
          ).to eq(["224952 work centre","224952 work centre","PROP - PROPERTY DEVELOPMENTS"])
        expect(response[:body]["ArticleDetails"]["EventCount"]).to eq('3')
      end
    end
  end

  context 'when authentication is not valid' do
    it 'should return 401' do
      stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.xml?q=CZ299999784AU")
          .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
          .to_return(:status => 401, :body => 'This request requires HTTP authentication (Bad credentials)',
                     :headers => {"Content-Type" => "text/html;charset=utf-8"})

      response = client.track('CZ299999784AU')

      expect(response[:status]).to eq(401)
      expect(response[:error]).to eq('This request requires HTTP authentication (Bad credentials)')
    end
  end

  context 'when tracking id is not valid' do
    let(:invalid_id_response) { File.read('spec/fixtures/auspost_invalid_id.xml') }

    it 'should return 404' do
      stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.xml?q=123")
            .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
            .to_return(:status => 200, :body => invalid_id_response,
                       :headers => {"Content-Type" => "application/xml;version=1\r\n"})

      response = client.track('123')

      expect(response[:status]).to eq("1401")
      expect(response[:error]).to eq('Invalid tracking ID')
    end
  end

  context 'when tracking id is not valid but AUSPost does not tell us' do

    it 'should return 500' do
      stub_request(:get, "https://anonymous%40auspost.com.au:password@devcentre.auspost.com.au/myapi/QueryTracking.xml?q=CZ299991784AU")
                    .with(:headers => {'Cookie'=>'OBBasicAuth=fromDialog'})
                    .to_return(:status => 503,
                               :headers => {"Content-Type" => "text/xml"})

      response = client.track('CZ299991784AU')

      expect(response[:status]).to eq(503)
      expect(response[:error]).to eq('Service Unavailable or Consignment ID is not valid')
    end

  end
end