# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/refund
  #
  # Refunds
  # A collection of endpoints for creating and managing transaction reimbursement
  module Refund
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/refund/#list
    # List Refunds: GET /refund
    #
    # @param perPage [Integer]
    #        Number of records to fetch per page
    # @param page [Integer]
    #        The section to retrieve
    # @param from [Time]
    #        The start date
    # @param to [Time]
    #        The end date
    #
    # @return [ListResponse] successful response
    # @raise [ListError] if the request fails
    api_method def self.list(per_page: nil, page: nil, from: nil, to: nil)
      use_connection do |connection|
        connection.get(
          '/refund',
          { perPage: per_page, page:, from:, to: }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :transaction,
               :integration,
               :deducted_amount,
               :channel,
               :merchant_note,
               :customer_note,
               :refunded_by,
               :expected_at,
               :currency,
               :domain,
               :amount,
               :fully_deducted,
               :id,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/refund/#create
    # Create Refund: POST /refund
    #
    # @param transaction [String] (required)
    #        Transaction reference or id
    # @param amount [Integer]
    #        Amount ( in kobo if currency is NGN, pesewas, if currency is GHS, and cents, if
    #        currency is ZAR ) to be refunded to the customer. Amount cannot be more than the
    #        original transaction amount
    # @param currency [String]
    #        Three-letter ISO currency. Allowed values are NGN, GHS, ZAR or USD
    # @param customer_note [String]
    #        Customer reason
    # @param merchant_note [String]
    #        Merchant reason
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(transaction:, amount: nil, currency: nil, customer_note: nil, merchant_note: nil)
      use_connection do |connection|
        connection.post(
          '/refund',
          { transaction:, amount:, currency:, customer_note:, merchant_note: }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :integration,
               :transaction,
               :dispute,
               :settlement,
               :id,
               :domain,
               :currency,
               :amount,
               :refunded_at,
               :refunded_by,
               :customer_note,
               :merchant_note,
               :deducted_amount,
               :fully_deducted,
               :createdAt,
               :bank_reference,
               :transaction_reference,
               :reason,
               :customer,
               :refund_type,
               :transaction_amount,
               :initiated_by,
               :refund_channel,
               :session_id,
               :collect_account_number, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/refund/#fetch
    # Fetch Refund: GET /refund/{id}
    #
    # @param id [String] (required)
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch(id:)
      use_connection do |connection|
        connection.get(
          "/refund/#{id}",
        )
      end
    end
  end
end
