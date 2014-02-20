require 'spec_helper'

describe 'order_status.haml' do
  context 'an In Progress order with some items' do

    before do
      @details = double(FulfilmentResponse,
          order_number: 'VF123MULTILINES', status_heading: 'In Progress', status_message: 'Your order is in progress.',
          estimated_shipping_date: nil, is_on_backorder?: false,
          items: [
              {item_quantity: "1", description: 'Samsung Galaxy'},
              {item_quantity: "2", description: 'iPhone 5C'},
              {item_quantity: "3", description: %q{Hooray for special characters! ./?/<h1>!@#$%^&*(;:)_+''=-,\"`}}
          ],
          show_tracking_events?: nil
      )
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
      expect(items.first).to have_content('Samsung Galaxy')
      expect(items[1]).to have_content('iPhone 5C')
      quantities = page.all('.item-quantity')
      expect(quantities.size).to be(3)
      expect(quantities.first).to have_content('1 x')
      expect(quantities[1]).to have_content('2 x')
      expect(page.find('.order-details-heading')).to have_content('Order Details')
    end

    it 'should HTML escape the special characters' do
      response.should include(%q{Hooray for special characters! ./?/&lt;h1&gt;!@#$%^&amp;*(;:)_+''=-,\&quot;`})
    end

  end

  context 'an In Progress order with some items of different statuses' do

    before do
      @details = double(FulfilmentResponse,
        order_number: 'VF123MULTILINES', status_heading: 'In Progress', status_message: 'Your order is in progress.',
        estimated_shipping_date: nil, is_on_backorder?: false,
        items: [
          {item_quantity: "1", description: 'Samsung Galaxy', status: 'Cancelled'},
          {item_quantity: "2", description: 'iPhone 5C', status: 'Shipped'},
          {item_quantity: "3", description: %q{Hooray for special characters! ./?/<h1>!@#$%^&*(;:)_+''=-,\"`}, status: 'On backorder'}
        ],
        show_tracking_events?: nil
      )
      render("/views/order_status.haml", :details => @details)
      #puts response
    end

    it 'should have item status fields' do
      item_statuses = page.all('.item-status')
      expect(item_statuses.size).to be(3)
      expect(item_statuses.first.text).to eq('Cancelled')
      expect(item_statuses[1].text).to eq('Shipped')
      expect(item_statuses.last.text).to eq('On backorder')
    end

  end

  context 'an In Progress order with no items' do

    before do
      @details = double(FulfilmentResponse,
          order_number: '1-123INPROGRESS', status_heading: 'In Progress', status_message: 'Your order is in progress.',
          estimated_shipping_date: nil, is_on_backorder?: false,
          items: [],
          show_tracking_events?: nil
      )
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

  context 'a Backordered order with an estimated shipping date' do
    before do
      @details = double(FulfilmentResponse,
          order_number: '1-123INPROGRESS', status_heading: 'On Backorder', status_message: 'Your order is on backorder.',
          estimated_shipping_date: '19 March 2014', is_on_backorder?: true, shipping_estimate_message: nil,
          items: [{item_quantity: '1', description: 'phone'}],
          show_tracking_events?: nil
      )
      render("/views/order_status.haml", :details => @details)
      #puts response
    end

    it 'should display the estimated shipping date' do
      expect(page.find('.status-heading')).to have_content('On Backorder')
      expect(page.find('.ship-date-heading')).to have_content('Expected Shipping Date')
      expect(page.find('.ship-date')).to have_content('19 March 2014')
      page.should have_no_selector('.ship-message')
    end
  end

  context 'a Backordered order with no estimated shipping date' do
    before do
      @details = double(FulfilmentResponse,
          order_number: '1-123INPROGRESS', status_heading: 'On Backorder', status_message: 'Your order is on backorder.',
          estimated_shipping_date: nil, is_on_backorder?: true, shipping_estimate_message: 'Your order should arrive soon',
          items: [{item_quantity: '1', description: 'phone'}],
          show_tracking_events?: nil
      )
      render("/views/order_status.haml", :details => @details)
      #puts response
    end

    it 'should display the estimated shipping date' do
      expect(page.find('.status-heading')).to have_content('On Backorder')
      expect(page.find('.ship-date-heading')).to have_content('Expected Shipping Date')
      page.should have_no_selector('.ship-date')
      expect(page.find('.ship-message')).to have_content('Your order should arrive soon')
    end
  end

end
