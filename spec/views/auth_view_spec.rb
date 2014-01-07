require 'spec_helper'

describe "Authentication form" do
  let(:fulfilment_client) { double(FulfilmentServiceProviderClient) }
  let(:mega_menu_client) { mega_menu_mock }
  let(:app) { App.new(mega_menu_client, fulfilment_client) }

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
    let(:url) { "/auth?order_id=#{order_id}&authType=#{auth_type}" }

    it { should be_ok }
    its(:body) { should match(order_id) }

    context 'email authentication' do
      let(:auth_type) { 'email' }
      its(:body) { should match /Email address/i }
      its(:body) { should_not match /Date of birth/i }
    end

    context 'birthday authentication' do
      let(:auth_type) { 'dob' }
      its(:body) { should_not match /Email address/i }
      its(:body) { should match /Date of birth/i }
    end

    context 'wrong auth type provided' do
      let(:auth_type) { 'something' }
      it { should be_redirect }
    end
  end

end