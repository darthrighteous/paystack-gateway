# frozen_string_literal: true

module PaystackGateway
  # Create and manage customers https://paystack.com/docs/api/customer/
  module Customers
    include PaystackGateway::RequestModule

    # Common helpers for response from customer endpoints
    module CustomerResponse
      extend ActiveSupport::Concern

      included do
        delegate :id, :customer_code, to: :data
      end
    end

    class CreateCustomerResponse < PaystackGateway::Response
      include CustomerResponse
    end

    api_method def self.create_customer(email:, first_name:, last_name:)
      use_connection do |connection|
        connection.post('/customer', { email:, first_name:, last_name: })
      end
    end

    # Response from GET /customer/:email_or_id
    class FetchCustomerResponse < PaystackGateway::Response
      include CustomerResponse

      delegate :subscriptions, :authorizations, to: :data

      def active_subscriptions = subscriptions.select { _1.status == 'active' }
      def active_subscription_codes = active_subscriptions.map(&:subscription_code)
      def reusable_authorizations = authorizations.select(&:reusable)
    end

    api_method def self.fetch_customer(email:)
      use_connection do |connection|
        connection.get("/customer/#{email}")
      end
    end
  end
end
