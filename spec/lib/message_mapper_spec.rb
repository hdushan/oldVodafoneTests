require 'spec_helper'

describe MessageMapper do

  describe '#error_message' do
    it 'should map known error messages' do
      mapper = MessageMapper.new
      mapper.error_message(503).should == 'Service Unavailable. Please, try again later.'
      mapper.error_message(404).should == 'That order ID was not found. Please, check that you typed it correctly.'
    end

    it 'should map unknown error messages' do
      mapper = MessageMapper.new
      mapper.error_message(678).should == 'There was a problem retrieving your order.'
    end
  end

  describe '#status_message' do
    it 'should map known statuses' do
      mapper = MessageMapper.new
      mapper.status_message('CANCELLED').should == 'Your order has been cancelled'
      mapper.status_message('IN PROGRESS').should == 'Your order is in progress'
      mapper.status_message('BACKORDERED').should == 'Your order is on backorder'
      mapper.status_message('SHIPPED').should == 'Your order has been shipped'
    end

    it 'should raise error if status is not known' do
      mapper = MessageMapper.new
      expect { mapper.status_message('UNKNOWN STATUS')}.to  raise_error /Invalid Order Status/
    end
  end

  describe '#status_heading' do
    it 'should map known statuses' do
      mapper = MessageMapper.new
      mapper.status_heading('CANCELLED').should == 'Order Cancelled'
      mapper.status_heading('IN PROGRESS').should == 'In Progress'
      mapper.status_heading('BACKORDERED').should == 'On Backorder'
      mapper.status_heading('SHIPPED').should == 'Order Shipped'
    end

    it 'should raise error if status is not known' do
      mapper = MessageMapper.new
      expect { mapper.status_heading('UNKNOWN STATUS')}.to  raise_error /Invalid Order Status/
    end
  end

end