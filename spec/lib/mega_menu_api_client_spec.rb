require 'rspec'
require 'spec_helper'

require_relative '../../lib/mega_menu/mega_menu_api_client'

describe 'Mega menu API client' do
  context 'for user using desktop browser' do
    let(:url) { 'https://www.vodafone.com.au/rest/SharedContent?name:contains=' }

    let(:desktop_header_body) { File.read('spec/fixtures/mega_header') }
    let(:desktop_footer_body) { File.read('spec/fixtures/mega_footer') }

    let(:mobile_header_body) { File.read('spec/fixtures/mobile_header') }
    let(:mobile_footer_body) { File.read('spec/fixtures/mobile_footer') }

    before(:each) do
      stub_request(:get, "#{url}MobileMenu").to_return(body: mobile_header_body)
      stub_request(:get, "#{url}MobileFooter").to_return(body: mobile_footer_body)

      stub_request(:get, "#{url}Mega_MenuV2").to_return(body: desktop_header_body)
      stub_request(:get, "#{url}Footer").to_return(body: desktop_footer_body)
    end

    subject { MegaMenuAPIClient.new().get_menu }

    it 'should download header for desktop' do
      response = subject['desktop']
      response['header_html'].should match /<h3>Sign in to My Vodafone<\/h3>/
      response['css'].should include '//www.vodafone.com.au/cs/static/mm/css/megamenus_v2.css'
      response['js'].should include '//www.vodafone.com.au/cs/static/mm/js/vha_mm_global_v2.js'
    end

    it 'should download footer for desktop' do
      response = subject['desktop']
      response['footer_html'].should match /<dt>About this site<\/dt>/
      response['css'].should include '//www.vodafone.com.au/cs/static/css/vha_global_vca.css'
    end

    it 'should download header for mobile' do
      response = subject['mobile']

      response['header_html'].should match /VHA MOBILE HD/
      response['css'].should include '//www.vodafone.com.au/cs/static/css/mobile/vha_vca_mobile_style.css'
      response['js'].should_not include '//www.vodafone.com.au/cs/static/js/mobile/vha_vca_mobile_global.js'
    end

    it 'should download footer for mobile' do
      response = subject['mobile']

      response['footer_html'].should match /<footer class=\"vha-vca-ft\">/
      response['css'].should_not include '//www.vodafone.com.au/cs/static/css/vha_global_vca.css'
    end
  end
end