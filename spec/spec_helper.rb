# frozen_string_literal: true
require 'bundler/setup'
Bundler.setup

require 'simplecov'

SimpleCov.start do
  add_filter 'config'
  add_filter 'vendor'
end

require 'require_all'
require 'rspec'
require 'byebug'
require 'webmock/rspec'
require 'tails/tails'
require_rel '../lib/tails/helpers/errors'

# Disable webrequests
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |conf|
  conf.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end

  conf.before do
    load './spec/helpers/worker_test.rb'
  end

  conf.after :suite do
    unless ENV['SKIP_LINTER'] == 'true'
      puts ''
      rubocop_command = 'bundle exec rubocop app spec services'
      raise 'RuboCop Errors' unless system rubocop_command
    end
  end
end
