# frozen_string_literal: true

module PaystackGateway
  # Create and manage transaction refunds.
  # https://paystack.com/docs/api/refund
  #
  # @deprecated Use PaystackGateway::Refund instead.
  module Refunds
    include PaystackGateway::RequestModule

    # Common helpers for responses from refunds endpoints
    module TransactionRefundResponse
      def refund_success? = transaction_status == :processed
      def refund_failed? = transaction_status == :failed
      def refund_pending? = transaction_status.in?(%i[pending processing])
    end

    # Response from POST /refund endpoint.
    class CreateResponse < PaystackGateway::Response
      include TransactionResponse
      include TransactionRefundResponse
    end

    api_method def self.create(transaction_reference_or_id:)
      use_connection do |connection|
        connection.post('/refund', { transaction: transaction_reference_or_id })
      end
    end

    # Response from GET /refund endpoint.
    class ListRefundsResponse < PaystackGateway::Response
      def pending_or_successful
        filtered = data.select { _1.status&.to_sym.in?(%i[processed pending processing]) }

        ListRefundsResponse.new({ **self, data: filtered })
      end

      def with_amount(amount)
        filtered = data.select { _1.amount == amount * 100 }

        ListRefundsResponse.new({ **self, data: filtered })
      end
    end

    api_method def self.list_refunds(transaction_id:)
      use_connection do |connection|
        connection.get('/refund', { transaction: transaction_id })
      end
    end

    # Response from GET /refund/:id endpoint.
    class FetchRefundResponse < PaystackGateway::Response
      include TransactionResponse
      include TransactionRefundResponse
    end

    api_method def self.fetch_refund(refund_id:)
      use_connection do |connection|
        connection.get("/refund/#{refund_id}")
      end
    end
  end
end
