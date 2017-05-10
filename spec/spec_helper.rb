# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "checkr/canada"

begin
  require "pry-byebug"
rescue LoadError # rubocop: disable Lint/HandleExceptions
end

require "webmock/rspec"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.mock_with :rspec

  config.order = :random
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
