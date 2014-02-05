require 'spec_helper'

describe 'order_status.haml' do
  context 'an In Progress order with some items' do

    before do
      @details = double(FulfilmentResponse,
                        order_number: 'VF123MULTILINES', status_heading: 'In Progress', status_message: 'Your order is in progress.',
                        items: [
                            {item_quantity: "1", description: 'Samsung Galaxy'},
                            {item_quantity: "2", description: 'iPhone 5C'},
                            {item_quantity: "3", description: %q{Hooray for special characters! ./?/<h1>!@#$%^&*(;:)_+''=-,\"`}}
                        ])
      render("/views/order_status.haml", :details => @details)
      #puts response
    end

    it 'should include the order number' do
      expect(page.find('.order-number-label')).to have_content('Order Status for order number:')
      expect(page.find('.order-number')).to have_content('VF123MULTILINES')
    end

    it 'should have order status fields' do
      expect(page.find('.status-heading')).to have_content('In Progress')
      expect(page.find('.status-message')).to have_content('Your order is in progress.')
    end

    it 'should have order details and order detail heading' do
      items = page.all('.item')
      expect(items.size).to be(3)
      expect(items.first).to have_content('1 x Samsung Galaxy')
      expect(items[1]).to have_content('2 x iPhone 5C')
      expect(page.find('.order-details-heading')).to have_content('Order Details')
    end

    it 'should HTML escape the special characters' do
      response.should include(%q{Hooray for special characters! ./?/&lt;h1&gt;!@#$%^&amp;*(;:)_+''=-,\&quot;`})
    end

  end

  context 'an In Progress order with no items' do

    before do
      @details = double(FulfilmentResponse,
                        order_number: '1-123INPROGRESS', status_heading: 'In Progress', status_message: 'Your order is in progress.',
                        items: [])
      render("/views/order_status.haml", :details => @details)
      #puts response
    end

    it 'should include the order number' do
      expect(page.find('.order-number-label')).to have_content('Order Status for order number:')
      expect(page.find('.order-number')).to have_content('1-123INPROGRESS')
    end

    it 'should have order status fields' do
      expect(page.find('.status-heading')).to have_content('In Progress')
      expect(page.find('.status-message')).to have_content('Your order is in progress.')
    end

    it 'should have no order details and no order detail heading' do
      page.should have_no_selector('.item')
      page.should have_no_selector('.order-details-heading')
    end
  end

end