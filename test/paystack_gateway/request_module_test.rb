# frozen_string_literal: true

require 'test_helper'

class RequestModuleTest < Minitest::Test
  module MockRequestModule
    include PaystackGateway::RequestModule

    class MockApiMethodResponse < PaystackGateway::Response; end

    api_method def self.mock_api_method
      use_connection { |connection| connection.get('/country') }
    end

    class MockApiErrorMethodError < PaystackGateway::ApiError; end

    api_method def self.mock_api_error_method
      use_connection { |connection| connection.get('/mock_failure') }
    end
  end

  MockRequestModule.send(:decorate_api_methods)

  def test_module_lists_api_methods
    assert_equal %i[mock_api_method mock_api_error_method], MockRequestModule.api_methods
  end

  def test_api_methods_make_requests_and_return_responses
    logger_info_mock = Minitest::Mock.new
    logger_info_mock.expect(:call, nil, ['request'])
    logger_info_mock.expect(:call, nil, ['response'])

    PaystackGateway.logger.stub(:info, logger_info_mock) do
      VCR.use_cassette 'miscellaneous/country_success' do
        response = MockRequestModule.mock_api_method

        assert_instance_of MockRequestModule::MockApiMethodResponse, response
      end
    end

    logger_info_mock.verify
  end

  def test_api_methods_are_decorated_with_current_attributes
    assert_message_received(
      PaystackGateway::Current,
      :with,
      api_module: MockRequestModule, api_method_name: :mock_api_method,
    ) { MockRequestModule.mock_api_method }

    assert_message_received(
      PaystackGateway::Current,
      :with,
      api_module: MockRequestModule, api_method_name: :mock_api_error_method,
    ) { MockRequestModule.mock_api_error_method }
  end

  def test_api_methods_are_decorated_with_error_handling
    assert_message_received(
      PaystackGateway.logger, :error,
      block_matcher: ->(&blk) { blk.call.match?(/RequestModuleTest::MockRequestModule#mock_api_error_method:.*404/) },
    ) do
      assert_message_received(
        PaystackGateway.logger, :debug,
        block_matcher: lambda { |&blk|
          blk.call.match?(
            /"request_method":.*"request_url":.*"request_headers":.*"response_headers":.*"response_body":/m,
          )
        },
      ) do
        error = assert_raises MockRequestModule::MockApiErrorMethodError do
          VCR.use_cassette 'mock_failure' do
            MockRequestModule.mock_api_error_method
          end
        end

        assert_match(/Paystack error:.*server.*responded.*404.*status:.*response:/, error.message)
      end
    end
  end
end
