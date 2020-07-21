ENV['APP_ENV'] = 'test'
require 'simplecov'
require 'simplecov-lcov'
require 'coveralls' if ENV['TRAVIS']

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
formatters = []
formatters << SimpleCov::Formatter::LcovFormatter
formatters << Coveralls::SimpleCov::Formatter if ENV['TRAVIS']
SimpleCov.formatters = formatters
SimpleCov.start do
  add_filter(/^\/spec\//)
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'puts_debuggerer' unless ENV['puts_debuggerer'] == 'false'
require 'glimmer-cw-video'
module GlimmerSpec
  include Glimmer::SWT::Packages # makes SWT packages available to namespace containing specs
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

FIXTURES_PATH = File.expand_path('../fixtures', __FILE__)

RSpec.configure do |config|
  # The following ensures rspec tests that instantiate and set Glimmer DSL widgets in @target get cleaned after
  config.after do
    @target.dispose if @target && @target.respond_to?(:dispose)
    Glimmer::DSL::Engine.reset
  end
  config.fail_fast = true unless ENV['TRAVIS']
end
