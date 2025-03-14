# frozen_string_literal: true

require 'paystack_gateway/version'
require 'paystack_gateway/configuration'
require 'paystack_gateway/api_error'
require 'paystack_gateway/current'
require 'paystack_gateway/request_module'
require 'paystack_gateway/response'
require 'paystack_gateway/transaction_response'

# Old Implementations, will be removed in a future version.
require 'paystack_gateway/customers'
require 'paystack_gateway/dedicated_virtual_accounts'
require 'paystack_gateway/plans'
require 'paystack_gateway/refunds'
require 'paystack_gateway/subaccounts'
require 'paystack_gateway/transactions'
require 'paystack_gateway/transfer_recipients'
require 'paystack_gateway/transfers'
require 'paystack_gateway/verification'
require 'paystack_gateway/webhooks'

# API Modules
require 'paystack_gateway/apple_pay'
require 'paystack_gateway/balance'
require 'paystack_gateway/bank'
require 'paystack_gateway/bulk_charge'
require 'paystack_gateway/charge'
require 'paystack_gateway/customer'
require 'paystack_gateway/dedicated_virtual_account'
require 'paystack_gateway/dispute'
require 'paystack_gateway/integration'
require 'paystack_gateway/miscellaneous'
require 'paystack_gateway/order'
require 'paystack_gateway/page'
require 'paystack_gateway/payment_request'
require 'paystack_gateway/plan'
require 'paystack_gateway/product'
require 'paystack_gateway/refund'
require 'paystack_gateway/settlement'
require 'paystack_gateway/split'
require 'paystack_gateway/storefront'
require 'paystack_gateway/subaccount'
require 'paystack_gateway/subscription'
require 'paystack_gateway/terminal'
require 'paystack_gateway/transaction'
require 'paystack_gateway/transfer'
require 'paystack_gateway/transfer_recipient'

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
