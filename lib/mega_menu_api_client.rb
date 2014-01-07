require 'httparty'
require 'json'

class MegaMenuAPIClient
  include HTTParty
  base_uri 'https://www.vodafone.com.au/rest'

  def initialize
    @parameters = {
        'mobile' => {
          'header' => {
            'url'         => 'MobileMenu',
            'css_names'   => ['vha_vca_mobile_style_css'],
            'js_names'    => []
          },

          'footer' => {
            'url'         => 'MobileFooter',
            'css_names'   => ['vha_vca_mobile_style'],
            'js_names'    => []
          }
        },

        'desktop' => {
          'header' => {
            'url'         => 'Mega_MenuV2',
            'css_names'   => ['mega_menu_cssv2'],
            'js_names'    => ['vha_mm_global_jsv2']
          },

          'footer' => {
            'url'         => 'Footer',
            'css_names'   => ['global_vca_css'],
            'js_names'    => []
          }
        }
    }
  end

  def get_menu(is_mobile_user)
    if is_mobile_user
      get_specific_menu(@parameters['mobile'])
    else
      get_specific_menu(@parameters['desktop'])
    end
  end

  def get_specific_menu(params)
    get_footer = Thread.new do
      @footer = get_element(params, 'footer')
    end

    get_header = Thread.new do
      @header = get_element(params, 'header')
    end

    get_footer.join
    get_header.join

    @header.merge(@footer) { |key, old_val, new_val| old_val + new_val }
  end

  def get_element(params, element_name)
    element = params[element_name]
    begin
      response_json = get_response_json(element['url'])
      {
        "#{element_name}_html" => html(response_json),
        'css' => element['css_names'].flat_map { |name| uri(find_by_name(response_json, name))},
        'js' => element['js_names'].flat_map { |name| uri(find_by_name(response_json, name)) }
      }
    rescue
      MegaMenuAPIClient.empty_response
    end
  end

  def get_response_json(type)
    JSON.parse(self.class.get("/SharedContent?name:contains=#{type}").body)
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
    def html(json)
      json[0]['source']['html']
    end

    def uri(list)
      list.collect { |res| res['uri'] }
    end

    def find_by_name(json, name)
      json[0]['resource'].select { |res| res.key?('name') && res['name'] == name }
    end
end