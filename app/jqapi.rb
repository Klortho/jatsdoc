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


    get '/' do
      content_type :html
      serve_file('docs', 'index.html')
    end

    # This takes care of HTML files anywhere under docs, including subdirectories
    # like, e.g., /docs/entries/how-to-use.html.
    get '/*.html' do
      content_type :html
      serve_file('docs', "#{params[:splat][0]}.html")
    end

    get '/resources/*' do
      send_file "docs/resources/#{params[:splat][0]}"
    end







    get 'LICENSE' do
      content_type 'text'
      serve_file('', 'LICENSE')
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
