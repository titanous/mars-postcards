require './app'

use Rack::Deflater
use Rack::Rewrite do
  r301 %r{.*}, 'http://marspostcards.com$&', if: lambda { |env|
    env['SERVER_NAME'] != 'marspostcards.com'
  }
end if ENV['RACK_ENV'] == 'production'

map App.assets_prefix do
  run App.sprockets
end

map '/' do
  run App
end
