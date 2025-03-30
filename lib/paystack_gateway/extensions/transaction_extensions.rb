# frozen_string_literal: true

require_relative 'transaction_response_extension'

module PaystackGateway
  module Extensions
    # Helpers for PaystackGateway::Transaction
    module TransactionExtensions
      # Helpers for PaystackGateway::Transaction::InitializeTransactionResponse
      module InitializeTransactionResponseExtension
        def payment_url
          authorization_url
        end
      end

      # Helpers for PaystackGateway::Transaction::InitializeTransactionError
      module InitializeTransactionErrorExtension
        def cancellable? = network_error?
      end

      # Helpers for PaystackGateway::Transaction::VerifyResponse
      module VerifyResponseExtension
        def transaction_completed_at = paid_at || super
      end

      # Helpers for PaystackGateway::Transaction::VerifyError
      module VerifyErrorExtension
        def transaction_not_found?
          return false if !response_body

          response_body[:status] == false && response_body[:message].match?(/transaction reference not found/i)
        end
      end
    end
  end
end

if PaystackGateway.use_extensions
  PaystackGateway::Transaction::InitializeTransactionResponse.include(
    PaystackGateway::Extensions::TransactionExtensions::InitializeTransactionResponseExtension,
  )
  PaystackGateway::Transaction::InitializeTransactionError.include(
    PaystackGateway::Extensions::TransactionExtensions::InitializeTransactionErrorExtension,
  )

  PaystackGateway::Transaction::VerifyResponse.include(
    PaystackGateway::Extensions::TransactionExtensions::VerifyResponseExtension,
    PaystackGateway::Extensions::TransactionResponseExtension,
  )
  PaystackGateway::Transaction::VerifyError.include(
    PaystackGateway::Extensions::TransactionExtensions::VerifyErrorExtension,
  )

  PaystackGateway::Transaction::ChargeAuthorizationResponse.include(
    PaystackGateway::Extensions::TransactionResponseExtension,
  )
end
