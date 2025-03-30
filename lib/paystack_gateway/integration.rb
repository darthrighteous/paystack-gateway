# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/integration
  #
  # Integration
  # A collection of endpoints for managing some settings on an integration
  module Integration
    include PaystackGateway::RequestModule

    # Successful response from calling #fetch_payment_session_timeout.
    class FetchPaymentSessionTimeoutResponse < PaystackGateway::Response; end

    # Error response from #fetch_payment_session_timeout.
    class FetchPaymentSessionTimeoutError < ApiError; end

    # https://paystack.com/docs/api/integration/#fetch_payment_session_timeout
    # Fetch Payment Session Timeout: GET /integration/payment_session_timeout
    #
    #
    # @return [FetchPaymentSessionTimeoutResponse] successful response
    # @raise [FetchPaymentSessionTimeoutError] if the request fails
    api_method def self.fetch_payment_session_timeout
      use_connection do |connection|
        connection.get(
          '/integration/payment_session_timeout',
        )
      end
    end

    # Successful response from calling #update_payment_session_timeout.
    class UpdatePaymentSessionTimeoutResponse < PaystackGateway::Response; end

    # Error response from #update_payment_session_timeout.
    class UpdatePaymentSessionTimeoutError < ApiError; end

    # https://paystack.com/docs/api/integration/#update_payment_session_timeout
    # Update Payment Session Timeout: PUT /integration/payment_session_timeout
    #
    # @param timeout [String] (required)
    #        Time in seconds before a transaction becomes invalid
    #
    # @return [UpdatePaymentSessionTimeoutResponse] successful response
    # @raise [UpdatePaymentSessionTimeoutError] if the request fails
    api_method def self.update_payment_session_timeout(timeout:)
      use_connection do |connection|
        connection.put(
          '/integration/payment_session_timeout',
          { timeout: }.compact,
        )
      end
    end
  end
end
