# frozen_string_literal: true

module PaystackGateway
  module Extensions
    # Helpers for PaystackGateway::Customer
    module CustomerExtensions
      # Helpers for PaystackGateway::Customer::FetchResponse
      module FetchResponseExtension
        def active_subscriptions = subscriptions.select { _1.status == 'active' }
        def active_subscription_codes = active_subscriptions.map(&:subscription_code)
        def reusable_authorizations = authorizations.select(&:reusable)
      end
    end
  end
end

if PaystackGateway.use_extensions
  PaystackGateway::Customer::FetchResponse.include(
    PaystackGateway::Extensions::CustomerExtensions::FetchResponseExtension,
  )
end
