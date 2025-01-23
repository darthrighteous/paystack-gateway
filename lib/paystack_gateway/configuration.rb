# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

# = PaystackGateway
module PaystackGateway
  # Encapsulates the configuration options for PaystackGateway including the
  # secret key, logger, logging_options, and log filter.
  class Configuration
    attr_accessor :secret_key, :logger, :logging_options, :log_filter

    def initialize
      @logger = Logger.new($stdout)
      @log_filter = lambda(&:dup)
    end
  end
end
