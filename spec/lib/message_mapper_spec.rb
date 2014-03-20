require 'spec_helper'

include StatusStrings

describe MessageMapper do

  describe '#error_message' do
    it 'should map known error messages' do
      mapper = MessageMapper.new
      mapper.error_message(503).should match /technical mishap/
      mapper.error_message(400).should match /entered your tracking number exactly/
      mapper.error_message(404).should match /entered your tracking number exactly/
    end

    it 'should map unknown error messages' do
      mapper = MessageMapper.new
      mapper.error_message(678).should match /technical mishap/
    end
  end

  describe '#status_message' do
    it 'should map known statuses' do
      mapper = MessageMapper.new
      mapper.status_message(TS_CANCELLED).should match /haven.t been charged/i
      mapper.status_message(TS_PROGRESS).should match /check back soon/i
      mapper.status_message(TS_BACKORDERED).should match /currently waiting/i
      mapper.status_message(TS_SHIPPED).should  be_nil
      mapper.status_message(TS_PARTIALLY_SHIPPED).should match /on its way/i
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
      mapper.status_heading(TS_PROGRESS).should =~ /working on your order/i
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
      mapper.item_status(IS_PROGRESS).should =~ /pending/i
    end

    it 'should return blank if status is not known' do
      mapper = MessageMapper.new
      mapper.item_status('eeek!').empty?.should be_true
    end
  end

end