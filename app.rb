require 'bundler'
require 'sass'
Bundler.require

class App < Sinatra::Base
  IMAGES = Dir.glob('assets/img/PIA*.jpg').map { |f| File.basename(f) }.sort.reverse

  set :sprockets, Sprockets::Environment.new(root)
  set :assets_prefix, '/assets'
  set :precompile, [/\w+\.(?!js|css).+/, /application.(css|js)$/]
  set :digest_assets, true
  set(:assets_path) { File.join(public_folder, assets_prefix) }

  enable :logging

  configure do
    sprockets.append_path File.join(root, 'assets', 'js')
    sprockets.append_path File.join(root, 'assets', 'css')
    sprockets.append_path File.join(root, 'assets', 'img')

    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix      = assets_prefix
      config.digest      = digest_assets
      config.public_path = public_folder
    end

    Slim::Engine.set_default_options pretty: true, disable_escape: true
  end


  helpers do
    include Sprockets::Helpers

    def nasa_link(image)
      'http://www.jpl.nasa.gov/spaceimages/details.php?id=' + image.match(/PIA\d{5}/)[0]
    end

    def postcard_url(image)
      url = "http://marspostcards.com/assets/#{image}.jpg"
      "https://www.touchnote.com/create-card-from-design/?refid=mars-postcards&imgsrc=#{url}"
    end

    def postcard_path(image)
      "/#{File.basename(image, '.jpg')}/postcard"
    end

    def postcard_id(image)
      image.split('.')[0]
    end
  end

  get '/' do
    slim :index
  end

  get '/:id/postcard' do
    redirect postcard_url(params[:id])
  end

  get '/favicon.ico' do
    cache_control :public, max_age: 31556952
    send_file 'favicon.ico'
  end
end
