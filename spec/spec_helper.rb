# frozen_string_literal: true

ENV['RUBY_ENV'] = 'test'

require 'simplecov'
SimpleCov.start do
  # filters.clear
  add_filter %w[/spec/]
  # add_group "lib", "../lib/"
  enable_coverage :branch
  # if ENV['CI']
  #   require 'simplecov-lcov'

  #   SimpleCov::Formatter::LcovFormatter.config do |c|
  #     c.report_with_single_file = true
  #     c.single_report_path = 'coverage/lcov.info'
  #   end

  #   formatter SimpleCov::Formatter::LcovFormatter
  # end
end

require_relative "../lib/lab42/stream"

Dir[File.join(SimpleCov.root, 'spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'tmp/rspec_failures.txt'

  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.raise_errors_for_deprecations!
end

# SPDX-License-Identifier: Apache-2.0
