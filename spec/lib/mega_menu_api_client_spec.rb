require 'rspec'
require 'webmock/rspec'

require_relative '../../lib/mega_menu/mega_menu_api_client'

describe 'Mega menu API client' do
  context 'for user using desktop browser' do
    let(:url) { 'https://www.vodafone.com.au/rest/SharedContent?name:contains=' }
    let(:url_header) { "#{url}Mega_MenuV2" }
    let(:url_footer) { "#{url}Footer" }

    let(:header_body) { File.read('spec/fixtures/mega_header') }
    let(:footer_body) { File.read('spec/fixtures/mega_footer') }
    let(:client) { MegaMenuAPIClient.new }

    before(:each) do
      stub_request(:get, url_header).to_return(body: header_body)
      stub_request(:get, url_footer).to_return(body: footer_body)
    end

    it 'should download header for desktop' do
      response = client.get_menu(false)

      response['header_html'].should match /<h3>Sign in to My Vodafone<\/h3>/
      response['css'].should include '//www.vodafone.com.au/cs/static/mm/css/megamenus_v2.css'
      response['js'].should include '//www.vodafone.com.au/cs/static/mm/js/vha_mm_global_v2.js'
    end

    it 'should download footer for desktop' do
      response = client.get_menu(false)

      response['footer_html'].should match /<dt>About this site<\/dt>/
      response['css'].should include '//www.vodafone.com.au/cs/static/css/vha_global_vca.css'
    end
  end

  context 'for user using mobile browser' do
    let(:url) { 'https://www.vodafone.com.au/rest/SharedContent?name:contains=' }
    let(:url_header) { "#{url}MobileMenu" }
    let(:url_footer) { "#{url}MobileFooter" }

    let(:header_body) { File.read('spec/fixtures/mobile_header') }
    let(:footer_body) { File.read('spec/fixtures/mobile_footer') }
    let(:client) { MegaMenuAPIClient.new }

    before(:each) do
      stub_request(:get, url_header).to_return(body: header_body)
      stub_request(:get, url_footer).to_return(body: footer_body)
    end

    it 'should download header for mobile' do
      response = client.get_menu(true)

      response['header_html'].should match /VHA MOBILE HD/
      response['css'].should include '//www.vodafone.com.au/cs/static/css/mobile/vha_vca_mobile_style.css'
      response['js'].should_not include '//www.vodafone.com.au/cs/static/js/mobile/vha_vca_mobile_global.js'
    end

    it 'should download footer for mobile' do
      response = client.get_menu(true)

      response['footer_html'].should match /<footer class=\"vha-vca-ft\">/
      response['css'].should_not include '//www.vodafone.com.au/cs/static/css/vha_global_vca.css'
    end
  end
end