require 'sinatra/base'
require 'sinatra/assetpack'

module Assets
  def self.included base
    base.instance_eval do
      register Sinatra::AssetPack
      set :public_folder, 'public'

      assets {
        serve '/tracking/fonts', from: 'assets/fonts'
        serve '/tracking/js', from: 'assets/javascripts' # Default
        serve '/tracking/css', from: 'assets/stylesheets' # Default
        serve '/tracking/images', from: 'assets/images' # Default

        # The second parameter defines where the compressed version will be served.
        # (Note: that parameter is optional, AssetPack will figure it out.)
        # The final parameter is an array of glob patterns defining the contents
        # of the package (as matched on the public URIs, not the filesystem)
        js :application, '/tracking/js/application.js', [
          '/tracking/js/vendor/*.js',
          '/tracking/js/*.js'
        ]

        js :ie8, '/tracking/js/ie8.js', [
          '/tracking/js/vendor/html5shiv.js'
        ]

        css :main, '/tracking/css/application.css', [
          '/tracking/css/app.css', '/tracking/css/loader.css'
        ]

        css :ie9, '/tracking/css/ie9only.css', [
          '/tracking/css/app.css', '/tracking/css/ieloader.css'
        ]

        css :ie8, '/tracking/css/ie8only.css', [
          '/tracking/css/ie8.css', '/tracking/css/ieloader.css'
        ]

        js_compression :jsmin # :jsmin | :closure | :uglify
        css_compression :sass # :simple | :sass | :yui | :sqwish
      }
    end
  end
end
