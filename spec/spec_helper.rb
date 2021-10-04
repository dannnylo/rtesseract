# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
require 'simplecov-lcov'

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
                                                                  SimpleCov::Formatter::HTMLFormatter,
                                                                  SimpleCov::Formatter::LcovFormatter
                                                                ])

SimpleCov.start :test_frameworks do
  enable_coverage :branch

  minimum_coverage line: 100, branch: 85
end

require 'rtesseract'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    RTesseract.reset_config!
  end
end
