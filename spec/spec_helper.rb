
require 'simplecov'
SimpleCov.start

require_relative "../lib/lab42/stream"

PROJECT_ROOT = File.expand_path "../..", __FILE__
Dir[File.join(PROJECT_ROOT,"spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |c|
  c.filter_run wip: true
  if ENV["EXCLUDE_SLOW"]
    c.filter_run_excluding slow: true
  end
  c.filter_run_excluding next: true
  c.run_all_when_everything_filtered = true
end

