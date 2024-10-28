# frozen_string_literal: true

module PaystackGateway
  # Supporting APIs that can be used to provide more details to other APIs
  # https://paystack.com/docs/api/#miscellaneous
  module Miscellaneous
    include PaystackGateway::RequestModule

    # Response from GET /bank endpoint.
    class ListBanksResponse < PaystackGateway::Response
      def bank_names = data.map(&:name)
      def bank_slugs = data.map(&:slug)

      def bank_details(*attributes) = data.map { _1.slice(*attributes) }

      def by_bank_names = data.index_by(&:name)
      def by_bank_codes = data.index_by(&:code)
    end

    # https://paystack.com/docs/api/miscellaneous/#bank
    api_method def self.list_banks(use_cache: true, pay_with_bank_transfer: false)
      cache_options =
        if use_cache
          { cache_key: pay_with_bank_transfer ? 'pay_with_bank_transfer' : nil }
        end

      with_response(ListBanksResponse, cache_options:) do |connection|
        connection.get('/bank', pay_with_bank_transfer ? { pay_with_bank_transfer: } : {})
      end
    end
  end
end
