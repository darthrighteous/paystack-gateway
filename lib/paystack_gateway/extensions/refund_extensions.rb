# frozen_string_literal: true

require_relative 'transaction_response_extension'

module PaystackGateway
  module Extensions
    # Helpers for PaystackGateway::Refund
    module RefundExtensions
      # Helpers for PaystackGateway::Refund::ListResponse
      module ListResponseExtension
        def pending_or_successful
          filtered = data.select { _1.status&.to_sym.in?(%i[processed pending processing]) }

          ListResponse.new({ **self, data: filtered })
        end

        def with_amount(amount)
          filtered = data.select { _1.amount == amount * 100 }

          ListResponse.new({ **self, data: filtered })
        end
      end
    end

    # Common helpers for responses from refunds endpoints
    module TransactionRefundResponseExtension
      def refund_success? = transaction_status == :processed
      def refund_failed? = transaction_status == :failed
      def refund_pending? = transaction_status.in?(%i[pending processing])
    end
  end
end

if PaystackGateway.use_extensions
  PaystackGateway::Refund::ListResponse.include(
    PaystackGateway::Extensions::RefundExtensions::ListResponseExtension,
  )

  PaystackGateway::Refund::CreateResponse.include(
    PaystackGateway::Extensions::TransactionResponseExtension,
    PaystackGateway::Extensions::TransactionRefundResponseExtension,
  )

  PaystackGateway::Refund::FetchResponse.include(
    PaystackGateway::Extensions::TransactionResponseExtension,
    PaystackGateway::Extensions::TransactionRefundResponseExtension,
  )
end
