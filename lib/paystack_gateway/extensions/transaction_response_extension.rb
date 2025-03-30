# frozen_string_literal: true

require 'bigdecimal'

module PaystackGateway
  module Extensions
    # Helpers for various responses around transactions.
    module TransactionResponseExtension
      def transaction_success? = %i[success reversed reversal_pending].include?(transaction_status)
      def transaction_abandoned? = transaction_status == :abandoned
      def transaction_failed? = transaction_status == :failed
      def transaction_pending? = %i[pending ongoing].include?(transaction_status)

      def transaction_status = data.status.to_sym
      def transaction_amount_in_major_units = amount / BigDecimal(100)
      def transaction_completed_at = data[:updatedAt]

      def subaccount_amount_in_major_units
        return if !subaccount || !fees_split

        fees_split.subaccount / BigDecimal(100)
      end

      def failure_reason
        return if !transaction_failed? && !transaction_abandoned?

        data.gateway_response || transaction_status || message
      end
    end
  end
end
