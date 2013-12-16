require_relative '../../lib/app_helper.rb'
require 'spec_helper'

describe 'app_helper' do

  describe '#generate_auth_url' do
    let(:order_id) { 'kitty' }
    let(:email) { 'abc@example.com' }
    let(:dob) { '1976-12-30' }

    subject do
      generate_auth_url(status_details, order_id)
    end

    context 'both email and date of birth are available' do
      let(:status_details) { { 'email' => email, 'date_of_birth' => dob} }
      it { should eql "/auth?order_id=#{order_id}&authType=email" }
    end

    context 'only email is available' do
      let(:status_details) { { 'email' => email, 'date_of_birth' => nil} }
      it { should eql "/auth?order_id=#{order_id}&authType=email" }
    end

    context 'only dob is available' do
      let(:status_details) { { 'email' => nil, 'date_of_birth' => dob} }
      it { should eql "/auth?order_id=#{order_id}&authType=dob" }
    end

    context 'neither email nor date of birth is available' do
      let(:status_details) { { 'email' => nil, 'date_of_birth' => nil} }
      it { should be_nil }
    end
  end
end
