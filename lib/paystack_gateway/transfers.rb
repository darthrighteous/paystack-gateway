# frozen_string_literal: true

module PaystackGateway
  # Automate sending money https://paystack.com/docs/api/#transfer
  module Transfers
    include PaystackGateway::RequestModule

    # Response from POST /transfer endpoint.
    class InitiateTransferResponse < PaystackGateway::Response
      include TransactionResponse

      delegate :transfer_code, :id, :transferred_at, to: :data

      def transaction_completed_at
        transferred_at || super
      end
    end

    # Raised when an error occurs while calling POST /transfer
    class InitiateTransferError < ApiError
      def transaction_failed?
        response_body[:status] == false && http_code == 400
      end

      def failure_reason
        response_body[:message]
      end
    end

    api_method def self.initiate_transfer(amount:, recipient_code:, reference:, reason: nil)
      response = with_response(InitiateTransferResponse) do |connection|
        connection.post(
          '/transfer',
          {
            source: :balance, amount: (amount * 100).to_i, recipient: recipient_code,
            reference: reference, reason: reason,
          }.compact,
        )
      end
      response.tap { |r| r.completed_at = Time.current }
    end

    # Response from GET /transfer/verify/:reference endpoint.
    class VerifyTransferResponse < InitiateTransferResponse; end

    # Raised when an error occurs while calling GET /transfer/verify/:reference
    class VerifyTransferError < ApiError
      def transaction_not_found?
        response_body[:status] == false && response_body[:message].match?(/transfer not found/i)
      end
    end

    api_method def self.verify_transfer(reference:)
      with_response(VerifyTransferResponse) do |connection|
        connection.get("/transfer/verify/#{reference}")
      end
    end
  end
end
