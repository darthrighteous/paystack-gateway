# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/settlement
  #
  # Settlements
  # A collection of endpoints for gaining insights into payouts
  module Settlement
    include PaystackGateway::RequestModule

    # Successful response from calling #s_fetch.
    class SFetchResponse < PaystackGateway::Response; end

    # Error response from #s_fetch.
    class SFetchError < ApiError; end

    # https://paystack.com/docs/api/settlement/#s_fetch
    # Fetch Settlements: GET /settlement
    #
    # @param perPage [Integer]
    # @param page [Integer]
    #
    # @return [SFetchResponse] successful response
    # @raise [SFetchError] if the request fails
    api_method def self.s_fetch(per_page: nil, page: nil)
      use_connection do |connection|
        connection.get(
          '/settlement',
          { perPage:, page: }.compact,
        )
      end
    end

    # Successful response from calling #s_transaction.
    class STransactionResponse < PaystackGateway::Response; end

    # Error response from #s_transaction.
    class STransactionError < ApiError; end

    # https://paystack.com/docs/api/settlement/#s_transaction
    # Settlement Transactions: GET /settlement/{id}/transaction
    #
    # @param id [String] (required)
    #
    # @return [STransactionResponse] successful response
    # @raise [STransactionError] if the request fails
    api_method def self.s_transaction(id:)
      use_connection do |connection|
        connection.get(
          "/settlement/#{id}/transaction",
        )
      end
    end
  end
end
