# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'paystack-gateway'

require 'minitest/autorun'
require 'faraday'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/fixtures'
  config.hook_into :faraday
  config.allow_http_connections_when_no_cassette = false

  config.filter_sensitive_data('Bearer <API_TOKEN>') do |interaction|
    interaction.request.headers['Authorization'].first
  end
end

module Minitest
  module Assertions
    # Fails unless +receiver+ received message +message+, optionally with +args+
    # (and +kwargs+). The message is stubbed to return +return_val+
    #
    # @example Asserting a method call with a block
    #   assert_message(SomeService, :some_method, *args, **kwargs) do
    #     SomeService.some_method(*args, **kwargs)
    #   end
    def assert_message_received(receiver, message, return_val = nil, args = [], **, &)
      mock = Minitest::Mock.new
      mock.expect(:call, return_val, args, **)

      receiver.stub(message, mock, &)

      begin
        assert_mock mock
      rescue MockExpectationError
        raise Minitest::Assertion, "Expected #{receiver} to receive #{message} with #{args.inspect}, but it did not."
      end
    end
  end
end
