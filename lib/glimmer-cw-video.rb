$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

require 'glimmer-dsl-swt'
require 'glimmer-dsl-xml'
require 'glimmer-dsl-css'
require 'views/glimmer/video'

Glimmer::Config::SAMPLE_DIRECTORIES << File.expand_path('../../samples/video', __FILE__)
