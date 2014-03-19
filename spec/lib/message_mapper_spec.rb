require 'spec_helper'

include StatusStrings

describe MessageMapper do

  describe '#error_message' do
    it 'should map known error messages' do
      mapper = MessageMapper.new
      mapper.error_message(503).should == 'Service Unavailable. Please, try again later.'
      mapper.error_message(400).should == 'The Order Number you have entered is not in a valid format. Please check the number on your confirmation email and enter it as it appears on the email.'
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
      mapper.status_message(TS_CANCELLED).should =~ /cancelled/i
      mapper.status_message(TS_PROGRESS).should be_nil
      mapper.status_message(TS_BACKORDERED).should =~ /backorder/i
      mapper.status_message(TS_SHIPPED).should  be_nil
      mapper.status_message(TS_PARTIALLY_SHIPPED).should =~ /partially shipped/i
    end

    it 'should raise error if status is not known' do
      mapper = MessageMapper.new
      expect { mapper.status_message('UNKNOWN STATUS')}.to  raise_error /Invalid Order Status/
    end
  end

  describe '#status_heading' do
    it 'should map known statuses' do
      mapper = MessageMapper.new
      mapper.status_heading(TS_CANCELLED).should =~ /cancelled/i
      mapper.status_heading(TS_PROGRESS).should =~ /progress/i
      mapper.status_heading(TS_BACKORDERED).should =~ /backorder/i
      mapper.status_heading(TS_SHIPPED).should  =~ /shipped/i
      mapper.status_heading(TS_PARTIALLY_SHIPPED).should =~ /partially shipped/i
    end

    it 'should raise error if status is not known' do
      mapper = MessageMapper.new
      expect { mapper.status_heading('UNKNOWN STATUS')}.to  raise_error /Invalid Order Status/
    end
  end

  describe '#item_status' do
    it 'should map known item statuses' do
      mapper = MessageMapper.new
      mapper.item_status(IS_CANCELLED).should =~ /cancelled/i
      mapper.item_status(IS_SHIPPED).should =~ /shipped/i
      mapper.item_status(IS_BACKORDERED).should =~ /backorder/i
      mapper.item_status(IS_PROGRESS).should =~ /progress/i
    end

    it 'should return blank if status is not known' do
      mapper = MessageMapper.new
      mapper.item_status('eeek!').empty?.should be_true
    end
  end

end