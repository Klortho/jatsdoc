require 'bundler'; Bundler.require

module Jqapi
  ASSET_PATHS = [
      'app/assets/javascripts',
      'app/assets/stylesheets',
      'app/assets/images',
      'vendor/assets/javascripts',
      'vendor/assets/stylesheets',
      'vendor/assets/images'
  ].freeze

  class Server < Sinatra::Base
    set :docset, $docset   # which set of documentation to serve
    set :root, File.join(File.dirname(__FILE__), '..')
    set :views, File.join(root, 'app/views')
    set :sprockets, Sprockets::Environment.new(root)
    set :precompile, [/\w+\.(?!js|css).+/, /bundle.(css|js)$/]
    set :assets_prefix, 'assets'
    set :assets_path, File.join(root, 'public', assets_prefix)

    configure do
      ASSET_PATHS.each do |path|
        sprockets.append_path(File.join(root, path))
      end
    end

    before do
      content_type :json
    end

    get '/docs/categories.json' do
      serve_file('docs', 'categories.json')
    end

    get '/docs/index.json' do
      serve_file('docs', 'index.json')
    end

    # This takes care of HTML files anywhere under docs, including subdirectories
    # like, e.g., /docs/entries/how-to-use.html.
    get '/docs/*.html' do
      if settings.docset == 'jats'
        content_type :html
        serve_file('docs', "#{params[:splat][0]}.html")
      end
    end



    get '/docs/versions.json' do
      serve_file('docs', 'versions.json')
    end

    get '/docs/entries/*.json' do
      serve_file('docs/entries', "#{params[:splat][0]}.json")
    end

    get 'resources/*.png' do
      content_type 'image/png'
      serve_file('docs/resources', "#{params[:splat][0]}.png")
    end

    get 'resources/*.jpg' do
      content_type 'image/jpeg'
      serve_file('docs/resources', "#{params[:splat][0]}.jpg")
    end

    get 'resources/*.gif' do
      content_type 'image/gif'
      serve_file('docs/resources', "#{params[:splat][0]}.gif")
    end

    get 'LICENSE' do
      content_type 'text'
      serve_file('', 'LICENSE')
    end

    get '/' do
      if settings.docset == 'jats'
        content_type :html
        serve_file('docs', 'index.html')
      else  # default is jqapi
        content_type :html
        haml :index
      end
    end


    private
    def serve_file(path, filename)
      filepath = File.join(settings.root, path, filename)

      if File.exists?(filepath)
        File.open(filepath).read
      else
        404
      end
    end
  end
end
