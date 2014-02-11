require 'spec_helper'

describe '_tracking_info.haml' do

  context 'has no error in getting tracking information' do
    let(:tracking_info) { {'foo' => 'bar'} }
    before do
      render("/views/_tracking_info.haml", :tracking => tracking_info)
    end

    it 'should display tracking information' do
      expect(page.find('.tracking-info-heading')).to have_content('Shipping Details')
    end
  end

end
