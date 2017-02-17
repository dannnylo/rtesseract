# encoding: UTF-8
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'coveralls'
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end
Coveralls.wear!

require 'rtesseract'
# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.after(:each) do
    RTesseract.configuration = RTesseract::Configuration.new
  end
end
