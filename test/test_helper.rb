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
    #   assert_message_received(SomeService, :some_method, *args, **kwargs) do
    #     SomeService.some_method(*args, **kwargs)
    #   end
    def assert_message_received(receiver, message, args = [], return_val: nil, block_matcher: nil, **, &)
      mock = Minitest::Mock.new
      mock.expect(:call, return_val, args, **, &block_matcher)

      receiver.stub(message, mock, &)

      assert_mock mock
    rescue MockExpectationError => e
      raise Minitest::Assertion, "Expected #{receiver} to receive #{message} " \
                                 "with #{args.inspect}, but it did not.\n" \
                                 "Instead, #{e.message}"
    end

    # Fails unless +receiver+ received message +message+ multiple times
    # with the specified expectations.
    #
    # @example Asserting multiple calls to a method
    #   assert_messages_received(SomeService, :some_method, [
    #     { args: [arg1], return_val: val1 },
    #     { args: [arg2], return_val: val2 }
    #   ]) do
    #     SomeService.some_method(arg1)
    #     SomeService.some_method(arg2)
    #   end
    def assert_messages_received(receiver, message, expectations, &)
      mock = Minitest::Mock.new

      expectations.each do |expectation|
        args = expectation[:args] || []
        kwargs = expectation[:kwargs] || {}
        return_val = expectation[:return_val]
        block_matcher = expectation[:block_matcher]

        mock.expect(:call, return_val, args, **kwargs, &block_matcher)
      end

      receiver.stub(message, mock, &)

      assert_mock mock
    rescue MockExpectationError => e
      raise Minitest::Assertion, "Expected #{receiver} to receive #{message} " \
                                 "multiple times with specified arguments, but expectations were not met.\n" \
                                 "Error: #{e.message}"
    end
  end
end
