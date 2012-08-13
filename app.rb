require 'bundler/setup'
require 'sinatra'
require 'slim'

IMAGES = Dir.glob('public/images/PIA*.jpg').map { |f| File.basename(f) }

helpers do
  def nasa_link(image)
    'http://www.jpl.nasa.gov/spaceimages/details.php?id=' + image.match(/PIA\d{5}/)[0]
  end

  def postcard_link(image)
    'http://www.touchnote.com/create-card-from-design/?refid=mars-postcards&imgsrc=http://mars.titn.us/images/' + image
  end
end

get '/' do
  slim :index
end

get %r{/images/.+\.jpg} do
  cache_control :public, max_age: 31556952
  send_file params[:matches][0]
end
