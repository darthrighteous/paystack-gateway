# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/bulkcharge
  #
  # Bulk Charges
  # A collection of endpoints for creating and managing multiple recurring payments
  module BulkCharge
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/bulk-charge/#list
    # List Bulk Charge Batches: GET /bulkcharge
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
          '/bulkcharge',
          { perPage: per_page, page:, from:, to: }.compact,
        )
      end
    end

    # Successful response from calling #initiate.
    class InitiateResponse < PaystackGateway::Response
      delegate :batch_code,
               :reference,
               :id,
               :integration,
               :domain,
               :total_charges,
               :pending_charges,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #initiate.
    class InitiateError < ApiError; end

    # https://paystack.com/docs/api/bulk-charge/#initiate
    # Initiate Bulk Charge: POST /bulkcharge
    #
    # @param charges [Array<Hash>] (required)
    #   @option charges [String] :authorization
    #           Customer's card authorization code
    #   @option charges [String] :amount
    #           Amount to charge on the authorization
    #
    # @return [InitiateResponse] successful response
    # @raise [InitiateError] if the request fails
    api_method def self.initiate(charges:)
      use_connection do |connection|
        connection.post(
          '/bulkcharge',
          { charges: }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :batch_code,
               :reference,
               :id,
               :integration,
               :domain,
               :total_charges,
               :pending_charges,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/bulk-charge/#fetch
    # Fetch Bulk Charge Batch: GET /bulkcharge/{code}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/bulkcharge/#{code}",
        )
      end
    end

    # Successful response from calling #charges.
    class ChargesResponse < PaystackGateway::Response; end

    # Error response from #charges.
    class ChargesError < ApiError; end

    # https://paystack.com/docs/api/bulk-charge/#charges
    # Fetch Charges in a Batch: GET /bulkcharge/{code}/charges
    #
    # @param code [String] (required)
    #        Batch code
    #
    # @return [ChargesResponse] successful response
    # @raise [ChargesError] if the request fails
    api_method def self.charges(code:)
      use_connection do |connection|
        connection.get(
          "/bulkcharge/#{code}/charges",
        )
      end
    end

    # Successful response from calling #pause.
    class PauseResponse < PaystackGateway::Response; end

    # Error response from #pause.
    class PauseError < ApiError; end

    # https://paystack.com/docs/api/bulk-charge/#pause
    # Pause Bulk Charge Batch: GET /bulkcharge/pause/{code}
    #
    # @param code [String] (required)
    #        Batch code
    #
    # @return [PauseResponse] successful response
    # @raise [PauseError] if the request fails
    api_method def self.pause(code:)
      use_connection do |connection|
        connection.get(
          "/bulkcharge/pause/#{code}",
        )
      end
    end

    # Successful response from calling #resume.
    class ResumeResponse < PaystackGateway::Response; end

    # Error response from #resume.
    class ResumeError < ApiError; end

    # https://paystack.com/docs/api/bulk-charge/#resume
    # Resume Bulk Charge Batch: GET /bulkcharge/resume/{code}
    #
    # @param code [String] (required)
    #        Batch code
    #
    # @return [ResumeResponse] successful response
    # @raise [ResumeError] if the request fails
    api_method def self.resume(code:)
      use_connection do |connection|
        connection.get(
          "/bulkcharge/resume/#{code}",
        )
      end
    end
  end
end
