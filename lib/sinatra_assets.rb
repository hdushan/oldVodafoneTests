require 'sinatra/base'
require 'sinatra/assetpack'

module Assets
  def self.included base
    base.instance_eval do
      register Sinatra::AssetPack
      set :public_folder, 'public'

      assets {
        serve '/fonts',  from: 'assets/fonts'
        serve '/js',     from: 'assets/javascripts'        # Default
        serve '/css',    from: 'assets/stylesheets'       # Default
        serve '/images', from: 'assets/images'    # Default

        # The second parameter defines where the compressed version will be served.
        # (Note: that parameter is optional, AssetPack will figure it out.)
        # The final parameter is an array of glob patterns defining the contents
        # of the package (as matched on the public URIs, not the filesystem)
        js :application, '/js/application.js', [
          '/js/vendor/*.js',
          '/js/*.js'
        ]

        css :application, '/css/application.css', [
          '/css/*.css'
        ]

        css :ie, '/css/ie.css', [
          '/css/ie/ie.css'
        ]

        js_compression  :closure    # :jsmin | :closure | :uglify
        css_compression :sass   # :simple | :sass | :yui | :sqwish
      }
    end
  end
end
