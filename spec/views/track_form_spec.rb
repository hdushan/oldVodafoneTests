require 'spec_helper'

describe 'track_form.haml' do
  let(:fulfilment_client) { double(FulfilmentServiceProviderClient) }
  let(:mega_menu_client) { mega_menu_mock }
  let(:app) { App.new(mega_menu_client, fulfilment_client) }

  before { get '/tnt' }

  it 'should have input for tracking id' do
    last_response.body.should have_form('/tnt', 'post', options ={}) do
      with_tag 'input', with: { name: 'tracking_id', type: 'text'}
    end
  end
end
