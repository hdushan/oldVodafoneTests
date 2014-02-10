require 'spec_helper'

describe '_tracking_info.haml' do

  let(:tracking_info) { {} }
  before do
    render("/views/_tracking_info.haml", :tracking => tracking_info)
  end

  context 'has no error in getting tracking information' do
    let(:tracking_info) { {'foo' => 'bar'} }

    it 'should display tracking information' do
      expect(page.find('.tracking-info-heading')).to have_content('Shipping Details')
      expect(page).to have_no_selector('.tracking-info-generic-msg')
    end
  end

  context 'has error in getting tracking information' do
    let(:tracking_info) { {'error' => 'kitten'} }

    it 'should display tracking information' do
      expect(page.find('.tracking-info-heading')).to have_content('Shipping Details')
      expect(page.find('.tracking-info-generic-msg')).to have_content('Your order has been shipped.')
    end
  end

end
