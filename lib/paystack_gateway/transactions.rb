# frozen_string_literal: true

module PaystackGateway
  # Create and manage payments https://paystack.com/docs/api/#transaction
  #
  # @deprecated Use PaystackGateway::Transaction instead.
  module Transactions
    include PaystackGateway::RequestModule

    # Response from POST /transaction/initialize endpoint.
    class InitializeTransactionResponse < PaystackGateway::Response
      delegate :authorization_url, to: :data

      alias payment_url authorization_url
    end

    # Raised when an error occurs while calling POST /transaction/initialize
    class InitializeTransactionError < ApiError
      def cancellable? = super || network_error?
    end

    # Response looks like this.
    # {
    #   "status": true,
    #   "message": "Authorization URL created",
    #   "data": {
    #     "authorization_url": "https://checkout.paystack.com/n4ysyedbuseog8c",
    #     "access_code": "n4ysyedbuseog8c",
    #     "reference": "hlr4bxhypt"
    #   }
    # }
    api_method def self.initialize_transaction(**transaction_data)
      raise ApiError.new(:invalid_amount, cancellable: true) if transaction_data[:amount].blank?
      raise ApiError.new(:invalid_reference, cancellable: true) if transaction_data[:reference].blank?
      raise ApiError.new(:invalid_email, cancellable: true) if transaction_data[:email].blank?

      transaction_data[:amount] = (transaction_data[:amount] * 100).to_i

      use_connection do |connection|
        connection.post('/transaction/initialize', transaction_data.compact)
      end
    end

    # Response from GET /transaction/verify/:reference endpoint.
    class VerifyTransactionResponse < PaystackGateway::Response
      include TransactionResponse

      delegate :paid_at, to: :data

      def transaction_completed_at
        paid_at || super
      end
    end

    # Raised when an error occurs while calling /transactions/verify/:reference
    class VerifyTransactionError < ApiError
      def transaction_not_found?
        return false if !response_body

        response_body[:status] == false && response_body[:message].match?(/transaction reference not found/i)
      end
    end

    api_method def self.verify_transaction(reference:)
      raise VerifyTransactionError, :invalid_reference if reference.blank?

      use_connection do |connection|
        connection.get("/transaction/verify/#{reference}")
      end
    end

    # Response from POST /transaction/charge_authorization endpoint.
    class ChargeAuthorizationResponse < PaystackGateway::Response
      include TransactionResponse
    end

    api_method def self.charge_authorization(**transaction_data)
      raise ApiError.new(:invalid_amount, cancellable: true) if transaction_data[:amount].blank?
      raise ApiError.new(:invalid_reference, cancellable: true) if transaction_data[:reference].blank?
      raise ApiError.new(:invalid_authorization_code, cancellable: true) if transaction_data[:authorization_code].blank?
      raise ApiError.new(:invalid_email, cancellable: true) if transaction_data[:email].blank?

      transaction_data[:amount] = (transaction_data[:amount] * 100).to_i

      use_connection do |connection|
        connection.post('/transaction/charge_authorization', transaction_data.compact)
      end
    end
  end
end
