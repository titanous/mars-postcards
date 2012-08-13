require 'bundler/setup'
require 'sinatra'
require 'slim'

IMAGES = Dir.glob('public/images/PIA*.jpg').map { |f| File.basename(f) }.sort

helpers do
  def nasa_link(image)
    'http://www.jpl.nasa.gov/spaceimages/details.php?id=' + image.match(/PIA\d{5}/)[0]
  end

  def postcard_url(image)
    "https://www.touchnote.com/create-card-from-design/?refid=mars-postcards&imgsrc=http://marspostcards.com/images/#{image}.jpg"
  end

  def postcard_path(image)
    "/#{File.basename(image, '.jpg')}/postcard"
  end
end

get '/' do
  slim :index
end

get '/:id/postcard' do
  redirect postcard_url(params[:id])
end

get %r{/images/.+\.jpg} do
  cache_control :public, max_age: 31556952
  send_file params[:matches][0]
end
