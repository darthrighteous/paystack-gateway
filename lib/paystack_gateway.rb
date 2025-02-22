# frozen_string_literal: true

require 'paystack_gateway/version'
require 'paystack_gateway/configuration'
require 'paystack_gateway/api_error'
require 'paystack_gateway/current'
require 'paystack_gateway/request_module'
require 'paystack_gateway/response'
require 'paystack_gateway/transaction_response'

require 'paystack_gateway/customers'
require 'paystack_gateway/dedicated_virtual_accounts'
require 'paystack_gateway/miscellaneous'
require 'paystack_gateway/plans'
require 'paystack_gateway/refunds'
require 'paystack_gateway/subaccounts'
require 'paystack_gateway/transactions'
require 'paystack_gateway/transfer_recipients'
require 'paystack_gateway/transfers'
require 'paystack_gateway/verification'
require 'paystack_gateway/webhooks'

# = PaystackGateway
module PaystackGateway
  class << self
    attr_writer :config

    delegate :secret_key, :logger, :logging_options, :log_filter, to: :config

    def config = @config ||= Configuration.new
    def configure = yield(config)

    def api_modules
      constants.filter_map do |const_name|
        const = const_get(const_name)

        const if const.is_a?(Module) && const.included_modules.include?(RequestModule)
      end
    end
  end

  api_modules.each { |mod| mod.send(:decorate_api_methods) }
end
