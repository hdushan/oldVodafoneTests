require 'httparty'
require 'json'
require_relative 'mega_menu_params'

class MegaMenuAPIClient
  include HTTParty
  base_uri 'https://www.vodafone.com.au/rest/SharedContent?name:contains='

  def get_menu(is_mobile_user)
    get_specific_menu(mega_menu_params[is_mobile_user ? 'mobile' : 'desktop'])
  end

  def self.empty_response
    {
      'header_html' => '',
      'footer_html' => '',
      'html'        => '',
      'css'         => [],
      'js'          => []
    }
  end

  private
    def get_specific_menu(params)
      menu = {}
      %w(footer header).each do |name|
        t = Thread.new do
          menu[name] = get_menu_part(params, name)
        end
        t.join
      end

      menu['header'].merge(menu['footer']) { |key, old_val, new_val| old_val + new_val }
    end

    def get_menu_part(params, menu_part_name)
      menu_part_params = params[menu_part_name]
      begin
        response_json = get_response_json(menu_part_params['url'])
        {
            "#{menu_part_name}_html" => extract_html(response_json),
            'css' => menu_part_params['css_names'].flat_map { |css_file_name| collect_uri(extract_by_name(response_json, css_file_name))},
            'js' => menu_part_params['js_names'].flat_map { |js_file_name| collect_uri(extract_by_name(response_json, js_file_name)) }
        }
      rescue
        MegaMenuAPIClient.empty_response
      end
    end

    def get_response_json(url)
      JSON.parse(self.class.get(url).body)
    end

    def collect_uri(list)
      list.collect { |element| element['uri'] }
    end

    def extract_html(json)
      json[0]['source']['html']
    end

    def extract_by_name(json, name)
      json[0]['resource'].select { |res| res.key?('name') && res['name'] == name }
    end
end