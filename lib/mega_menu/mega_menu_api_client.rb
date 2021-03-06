require 'httparty'
require 'json'
require_relative 'mega_menu_params'

class MegaMenuAPIClient
  include HTTParty
  base_uri 'https://www.vodafone.com.au/rest/SharedContent?name:contains='
  default_timeout 10

  def get_menu
    mega_menu = {}
    mega_menu['mobile'] = get_specific_menu(mega_menu_params['mobile'])
    mega_menu['desktop'] = get_specific_menu(mega_menu_params['desktop'])
    mega_menu
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
      menu_sections = {}
      pull_menu_sections(menu_sections, params)
      merge_menu_sections(menu_sections)
    end

    def pull_menu_sections(menu_sections, params)
      params.keys.each do |name|
        Thread.new do
          menu_sections[name] = get_menu_section(name, params)
        end.join
      end
    end

    def merge_menu_sections(menu_sections)
      menu_sections.values.inject({}) do |result, element|
        result.merge!(element) { |key, old_val, new_val| old_val == new_val ? old_val : old_val + new_val  }
      end
    end

    def get_menu_section(menu_section_name, params)
      menu_section_params = params[menu_section_name]
      begin
        response_json = get_response_json(menu_section_params['url'])
        extract_menu_section_from_response(menu_section_name, menu_section_params, response_json)
      rescue
        MegaMenuAPIClient.empty_response
      end
    end

    def extract_menu_section_from_response(menu_part_name, menu_part_params, response_json)
      {
        "#{menu_part_name}_html" => extract_html(response_json),
        'css' => menu_part_params['css_names'].flat_map { |css_file_name| collect_uri(extract_by_name(response_json, css_file_name)) },
        'js' => menu_part_params['js_names'].flat_map { |js_file_name| collect_uri(extract_by_name(response_json, js_file_name)) }
      }
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
      resource = json[0]['resource']
      if resource.class == Array
        resource.select { |res| res.key?('name') && res['name'] == name }
      elsif resource.class == Hash
        if resource['name'] == name
          [resource]
        else
          []
        end
      end
    end
end