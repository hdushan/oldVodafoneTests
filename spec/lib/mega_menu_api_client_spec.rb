require 'rspec'
require 'webmock/rspec'
require 'pry'

require_relative '../../lib/mega_menu/mega_menu_api_client'

describe 'Mega menu API client' do
  context 'user using desktop browser' do
    let(:url) { 'https://www.vodafone.com.au/rest/SharedContent?name:contains=' }
    let(:url_header) { "#{url}Mega_MenuV2" }
    let(:url_footer) { "#{url}Footer" }

    let(:header_body) { File.read('spec/fixtures/mega_header') }
    let(:footer_body) { File.read('spec/fixtures/footer') }
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

    it 'should download footer desktop version' do
      response = client.get_menu(false)

      response['footer_html'].should match /<dt>About this site<\/dt>/
      response['css'].should include '//www.vodafone.com.au/cs/static/css/vha_global_vca.css'
    end

  end
end