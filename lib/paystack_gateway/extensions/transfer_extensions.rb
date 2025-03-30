# frozen_string_literal: true

require_relative 'transaction_response_extension'

module PaystackGateway
  module Extensions
    # Helpers for PaystackGateway::Transfer
    module TransferExtensions
      # Helpers for PaystackGateway::Transfer::InitiateResponse
      module InitiateResponseExtension
        def transaction_completed_at = transferred_at || super
      end

      # Helpers for PaystackGateway::Transfer::InitiateError
      module InitiateErrorExtension
        def transaction_failed? = response_body[:status] == false && http_code == 400
        def failure_reason = response_body[:message]
      end

      # Helpers for PaystackGateway::Transfer::VerifyResponse
      module VerifyResponseExtension
        def transaction_completed_at = transferred_at || super
      end

      # Helpers for PaystackGateway::Transfer::VerifyError
      module VerifyErrorExtension
        def transaction_not_found?
          response_body[:status] == false && response_body[:message].match?(/transfer not found/i)
        end
      end
    end
  end
end

if PaystackGateway.use_extensions
  PaystackGateway::Transfer::InitiateResponse.include(
    PaystackGateway::Extensions::TransferExtensions::InitiateResponseExtension,
    PaystackGateway::Extensions::TransactionResponseExtension,
  )
  PaystackGateway::Transfer::InitiateError.include(
    PaystackGateway::Extensions::TransferExtensions::InitiateErrorExtension,
  )

  PaystackGateway::Transfer::VerifyResponse.include(
    PaystackGateway::Extensions::TransferExtensions::VerifyResponseExtension,
  )
  PaystackGateway::Transfer::VerifyError.include(
    PaystackGateway::Extensions::TransferExtensions::VerifyErrorExtension,
  )
end
