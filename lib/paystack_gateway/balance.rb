# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/balance
  #
  # Balance
  # A collection of endpoints gaining insights into the amount on an integration
  module Balance
    include PaystackGateway::RequestModule

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response; end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/balance/#fetch
    # Fetch Balance: GET /balance
    # You can only transfer from what you have
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          '/balance',
        )
      end
    end

    # Successful response from calling #ledger.
    class LedgerResponse < PaystackGateway::Response; end

    # Error response from #ledger.
    class LedgerError < ApiError; end

    # https://paystack.com/docs/api/balance/#ledger
    # Balance Ledger: GET /balance/ledger
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
    # @return [LedgerResponse] successful response
    # @raise [LedgerError] if the request fails
    api_method def self.ledger(per_page: nil, page: nil, from: nil, to: nil)
      use_connection do |connection|
        connection.get(
          '/balance/ledger',
          { perPage: per_page, page:, from:, to: }.compact,
        )
      end
    end
  end
end
