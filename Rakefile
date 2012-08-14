require './app'
require 'rake/sprocketstask'

Rake::SprocketsTask.new do |t|
  t.environment = App.sprockets
  t.output      = './public/assets'
  t.assets      = %w(style.css)
end

task :default => :assets
