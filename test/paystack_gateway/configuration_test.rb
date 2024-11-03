# frozen_string_literal: true

require 'test_helper'

class ConfigurationTest < Minitest::Test
  def test_default_values
    config = PaystackGateway::Configuration.new

    assert_instance_of Logger, config.logger
    refute_nil config.log_filter

    assert_nil config.secret_key
    assert_nil config.logging_options
  end
end

class PaystackGatewayTest < Minitest::Test
  def teardown
    PaystackGateway.config = PaystackGateway::Configuration.new
  end

  def test_default_config
    assert_instance_of PaystackGateway::Configuration, PaystackGateway.config
  end

  def test_configure
    PaystackGateway.configure do |config|
      config.secret_key = 'test_secret_key'
      config.logger = 'test_logger'
      config.logging_options = 'test_logging_options'
      config.log_filter = 'test_log_filter'
    end

    assert_equal 'test_secret_key', PaystackGateway.secret_key
    assert_equal 'test_logger', PaystackGateway.logger
    assert_equal 'test_logging_options', PaystackGateway.logging_options
    assert_equal 'test_log_filter', PaystackGateway.log_filter
  end
end
