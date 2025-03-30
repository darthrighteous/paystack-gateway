# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/miscellaneous
  #
  # Miscellaneous
  # A collection of endpoints that provides utility functions
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
    # @deprecated Use #Bank.list instead.
    api_method def self.list_banks(use_cache: true, pay_with_bank_transfer: false)
      use_connection(cache_options: use_cache ? {} : nil) do |connection|
        connection.get('/bank', pay_with_bank_transfer ? { pay_with_bank_transfer: } : {})
      end
    end

    # Successful response from calling #resolve_card_bin.
    class ResolveCardBinResponse < PaystackGateway::Response
      delegate :bin,
               :brand,
               :sub_brand,
               :country_code,
               :country_name,
               :card_type,
               :bank,
               :currency,
               :linked_bank_id, to: :data
    end

    # Error response from #resolve_card_bin.
    class ResolveCardBinError < ApiError; end

    # https://paystack.com/docs/api/miscellaneous/#resolve_card_bin
    # Resolve Card BIN: GET /decision/bin/{bin}
    #
    # @param bin [String] (required)
    #
    # @return [ResolveCardBinResponse] successful response
    # @raise [ResolveCardBinError] if the request fails
    api_method def self.resolve_card_bin(bin:)
      use_connection do |connection|
        connection.get(
          "/decision/bin/#{bin}",
        )
      end
    end

    # Successful response from calling #list_countries.
    class ListCountriesResponse < PaystackGateway::Response; end

    # Error response from #list_countries.
    class ListCountriesError < ApiError; end

    # https://paystack.com/docs/api/miscellaneous/#list_countries
    # List Countries: GET /country
    #
    #
    # @return [ListCountriesResponse] successful response
    # @raise [ListCountriesError] if the request fails
    api_method def self.list_countries
      use_connection do |connection|
        connection.get(
          '/country',
        )
      end
    end

    # Successful response from calling #avs.
    class AvsResponse < PaystackGateway::Response; end

    # Error response from #avs.
    class AvsError < ApiError; end

    # https://paystack.com/docs/api/miscellaneous/#avs
    # List States (AVS): GET /address_verification/states
    #
    # @param type [String]
    # @param country [String]
    # @param currency [String]
    #
    # @return [AvsResponse] successful response
    # @raise [AvsError] if the request fails
    api_method def self.avs(type: nil, country: nil, currency: nil)
      use_connection do |connection|
        connection.get(
          '/address_verification/states',
          { type:, country:, currency: }.compact,
        )
      end
    end
  end
end
