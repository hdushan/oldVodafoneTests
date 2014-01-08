def mega_menu_params
  {
      'mobile' => {
          'header' => {
              'url' => 'MobileMenu',
              'css_names' => ['vha_vca_mobile_style_css'],
              'js_names' => []
          },

          'footer' => {
              'url' => 'MobileFooter',
              'css_names' => ['vha_vca_mobile_style'],
              'js_names' => []
          }
      },

      'desktop' => {
          'header' => {
              'url' => 'Mega_MenuV2',
              'css_names' => ['mega_menu_cssv2'],
              'js_names' => ['vha_mm_global_jsv2']
          },

          'footer' => {
              'url' => 'Footer',
              'css_names' => ['global_vca_css'],
              'js_names' => []
          }
      }
  }
end