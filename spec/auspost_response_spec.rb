require 'spec_helper'


describe AusPostResponse do

  context 'when the request is valid' do
    context 'and international is returned' do
      let(:successful_response1) { httparty_response('spec/fixtures/auspost_success_international.json') }

      it 'should return data from the auspost' do
        auspost_response = AusPostResponse.new(successful_response1)

        expect(auspost_response.international?).to be_true
      end
    end

    context 'and domestic events are returned' do
      let(:successful_response2) { httparty_response('spec/fixtures/auspost_success_domestic.json') }

      it 'should return event details from the auspost' do
        auspost_response = AusPostResponse.new(successful_response2)

        expect(auspost_response.international?).to be_false
        expect(auspost_response.status).to eq('Delivered')
        expect(auspost_response.events.map { |event| event['description'] }).to eq(['Delivered','Delivered','Delivered'])
        expect(auspost_response.events.map { |event| event['location'] }).to eq(["224952 work centre","224952 work centre","PROP - PROPERTY DEVELOPMENTS"])
      end
    end
  end

  context 'when authentication is not valid' do
    it 'should return 401' do
      response = OpenStruct.new(parsed_response: 'This request requires HTTP authentication (Bad credentials)', code: 401)

      auspost_response = AusPostResponse.new(response)

      expect(auspost_response.has_error?).to be_true
      expect(auspost_response.error_message).to eq('Failed to get data from AusPost')
    end
  end

  context 'when tracking id is not valid' do
    let(:invalid_id_response) { httparty_response('spec/fixtures/auspost_invalid_id.json') }

    it 'should return error description' do
      auspost_response = AusPostResponse.new(invalid_id_response)

      expect(auspost_response.has_error?).to be_true
      expect(auspost_response.error_message).to eq('Invalid tracking ID')
    end
  end

  context 'when tracking id is not valid but AUSPost does not tell us' do

    it 'should return error description' do
      auspost_response = AusPostResponse.new(OpenStruct.new(parsed_response: nil, code: 503))

      expect(auspost_response.has_error?).to be_true
      expect(auspost_response.error_message).to eq('AusPost Service is not Unavailable')
    end

  end
end
