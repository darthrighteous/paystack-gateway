# frozen_string_literal: true

module PaystackGateway
  # Perform KYC processes https://paystack.com/docs/api/#verification
  module Verification
    include PaystackGateway::RequestModule

    # Response from GET /bank/resolve endpoint.
    class ResolveAccountNumberResponse < PaystackGateway::Response
      delegate :account_name, :bank_id, to: :data

      def account_valid?
        status && account_name.present?
      end
    end

    # Raised when an error occurs while calling /bank/resolve
    class ResolveAccountNumberError < ApiError
      def invalid_account?
        http_code == 422 && response_body[:status] == false
      end
    end

    api_method def self.resolve_account_number(account_number:, bank_code:)
      use_connection(cache_options: {}) do |connection|
        connection.get(
          '/bank/resolve',
          { account_number: account_number, bank_code: bank_code },
        )
      end
    end
  end
end
