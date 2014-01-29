require 'spec_helper'

describe MessageMapper do

  describe '#get_error_message' do
    it 'should map known error messages' do
      mapper = MessageMapper.new
      mapper.get_error_message(503).should == 'Service Unavailable. Please, try again later.'
      mapper.get_error_message(404).should == 'That order ID was not found. Please, check that you typed it correctly.'
    end

    it 'should map unknown error messages' do
      mapper = MessageMapper.new
      mapper.get_error_message(678).should == 'There was a problem retrieving your order.'
    end
  end

  describe '#get_status_message' do
    it 'should map known statuses' do
      mapper = MessageMapper.new
      mapper.get_status_message('BOOKED').should == 'Your order has been booked'
      mapper.get_status_message('CLOSED').should == 'Your order is successfully processed'
    end

    it 'should raise error if status is not known' do
      mapper = MessageMapper.new
      expect { mapper.get_status_message('UNKNOWN STATUS')}.to  raise_error /Invalid Order Status/
    end
  end


end