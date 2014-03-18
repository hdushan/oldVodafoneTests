require 'spec_helper'
require 'test_helper'
require 'fulfilment_client'

describe 'track_form.haml' do
  let(:fulfilment_client) { double(FulfilmentClient) }
  let(:mega_menu_client) { mega_menu_mock }
  let(:app) { App.new(mega_menu_client, fulfilment_client) }

  before { get '/tracking' }

  it 'should have input for tracking id' do
    last_response.body.should have_form('/tracking', 'post', options ={}) do
      with_tag 'input', with: { name: 'tracking_id', type: 'text'}
    end
  end
end
