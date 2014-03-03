require 'spec_helper'

describe 'order_status.haml' do
  context 'an order with an order number' do
    before do
      @order = double(FulfilmentResponse,
        order_number: 'VF123MULTILINES',
        orders: [{tracking_status: 'SHIPPED'}]
      )
      render("/views/order_status.haml", :order => @order)
      puts response
    end

    it 'should include the order number' do
      expect(page.find('.order-number-label')).to have_content('Order Status for order number:')
      expect(page.find('.order-number')).to have_content('VF123MULTILINES')
    end

  end
end