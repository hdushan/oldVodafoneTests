require 'spec_helper'

describe "Authentication form" do

  subject do
    get url
    last_response
  end

  context 'no order id provided' do
    let(:url) { '/auth' }
    it { should be_redirect }
  end

  context 'with order id provided' do
    let(:order_id) { 'vf123' }
    let(:auth_type) { 'email' }
    let(:url) { "/auth?orderID=#{order_id}&authType=#{auth_type}" }

    it { should be_ok }
    its(:body) { should match(order_id) }

    context 'email authentication' do
      let(:auth_type) { 'email' }
      its(:body) { should match /Email address/i }
    end

    context 'birthday authentication' do
      let(:auth_type) { 'bday' }
      its(:body) { should match /Date of birth/i }
    end

  end

end