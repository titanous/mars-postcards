require './app'
require 'rack/rewrite'

use Rack::Deflater
use Rack::Rewrite do
  r301 %r{.*}, 'http://marspostcards.com$&', if: lambda { |env|
    env['SERVER_NAME'] != 'marspostcards.com'
  }
end if ENV['RACK_ENV'] == 'production'
run Sinatra::Application
