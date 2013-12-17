require 'spec_helper'

describe 'track_form.haml' do
  before { get '/tnt' }

  it 'should have input for tracking id' do
    last_response.body.should have_form('/track', 'post', options ={}) do
      with_tag 'input', with: { name: 'tracking_id', type: 'text'}
    end
  end
end
