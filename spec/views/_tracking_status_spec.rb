require 'spec_helper'

describe '_tracking_status.haml' do

  before do
    render("/views/_tracking_status.haml", auspost_number: 'UPAPWTF',
                                                         status_message: 'I am a status that is very important for customers')
    #puts response
  end

  it 'should show the auspost status' do
    expect(page.find '#auspost-status').to have_content('I am a status that is very important for customers')
    expect(page.find '#auspost-number').to have_content('UPAPWTF')
    expect(page.find "a.auspost-link[href='http://auspost.com.au/track/track.html?id=UPAPWTF']").to have_content('AusPost')
  end

end