# frozen_string_literal: true

module PaystackGateway
  # Common helpers for responses from transaction endpoints
  module TransactionResponse
    extend ActiveSupport::Concern

    included do
      delegate :id, :amount, :subaccount, :fees_split, to: :data

      attr_writer :completed_at
    end

    def transaction_success? = transaction_status.in?(%i[success reversed reversal_pending])
    def transaction_abandoned? = transaction_status == :abandoned
    def transaction_failed? = transaction_status == :failed
    def transaction_pending? = transaction_status.in?(%i[pending ongoing])

    def transaction_status = data.status.to_sym
    def transaction_amount = amount / BigDecimal('100')
    def transaction_completed_at = data[:updatedAt] || @completed_at

    def subaccount_amount
      return if !subaccount || !fees_split

      fees_split.subaccount / BigDecimal('100')
    end

    def failure_reason
      return if !transaction_failed? && !transaction_abandoned?

      data.gateway_response || transaction_status || message
    end
  end
end
