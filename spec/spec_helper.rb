require 'simplecov'

module SimpleCov::Configuration
  def clean_filters
    @filters = []
  end
end

SimpleCov.configure do
  clean_filters
  load_adapter 'test_frameworks'
end

ENV["COVERAGE"] && SimpleCov.start do
  add_filter "/.rvm/"
end
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'bundler/setup'
Bundler.require(:default, :development)
require 'glimmer-cw-video'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

FIXTURES_PATH = File.expand_path('../fixtures', __FILE__)

RSpec.configure do |config|
  # The following ensures rspec tests that instantiate and set Glimmer DSL widgets in @target get cleaned after
  config.after do
    @target.dispose if @target && @target.respond_to?(:dispose)
    Glimmer::DSL::Engine.reset
  end
  config.fail_fast = true
end

require 'glimmer/rake_task'
