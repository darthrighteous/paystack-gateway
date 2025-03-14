# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/transfer
  #
  # Transfers
  # A collection of endpoints for automating sending money to beneficiaries
  module Transfer
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/transfer/#list
    # List Transfers: GET /transfer
    #
    # @param perPage [Integer]
    #        Number of records to fetch per page
    # @param page [Integer]
    #        The section to retrieve
    # @param status [String]
    # @param from [Time]
    #        The start date
    # @param to [Time]
    #        The end date
    #
    # @return [ListResponse] successful response
    # @raise [ListError] if the request fails
    api_method def self.list(per_page: nil, page: nil, status: nil, from: nil, to: nil)
      use_connection do |connection|
        connection.get(
          '/transfer',
          { perPage:, page:, status:, from:, to: }.compact,
        )
      end
    end

    # Successful response from calling #initiate.
    class InitiateResponse < PaystackGateway::Response
      delegate :transfersessionid,
               :domain,
               :amount,
               :currency,
               :reference,
               :source,
               :source_details,
               :reason,
               :failures,
               :transfer_code,
               :titan_code,
               :transferred_at,
               :id,
               :integration,
               :request,
               :recipient,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #initiate.
    class InitiateError < ApiError; end

    # https://paystack.com/docs/api/transfer/#initiate
    # Initiate Transfer: POST /transfer
    #
    # @param source [String] (required)
    #        Where should we transfer from? Only balance is allowed for now
    # @param amount [String] (required)
    #        Amount to transfer in kobo if currency is NGN and pesewas if currency is GHS.
    # @param recipient [String] (required)
    #        The transfer recipient's code
    # @param reason [String]
    #        The reason or narration for the transfer.
    # @param currency [String]
    #        Specify the currency of the transfer. Defaults to NGN.
    # @param reference [String]
    #        If specified, the field should be a unique identifier (in lowercase) for the object.
    #        Only -,_ and alphanumeric characters are allowed.
    #
    # @return [InitiateResponse] successful response
    # @raise [InitiateError] if the request fails
    api_method def self.initiate(
      source:,
      amount:,
      recipient:,
      reason: nil,
      currency: nil,
      reference: nil
    )
      use_connection do |connection|
        connection.post(
          '/transfer',
          {
            source:,
            amount:,
            recipient:,
            reason:,
            currency:,
            reference:,
          }.compact,
        )
      end
    end

    # Successful response from calling #finalize.
    class FinalizeResponse < PaystackGateway::Response; end

    # Error response from #finalize.
    class FinalizeError < ApiError; end

    # https://paystack.com/docs/api/transfer/#finalize
    # Finalize Transfer: POST /transfer/finalize_transfer
    #
    # @param transfer_code [String] (required)
    #        The transfer code you want to finalize
    # @param otp [String] (required)
    #        OTP sent to business phone to verify transfer
    #
    # @return [FinalizeResponse] successful response
    # @raise [FinalizeError] if the request fails
    api_method def self.finalize(transfer_code:, otp:)
      use_connection do |connection|
        connection.post(
          '/transfer/finalize_transfer',
          { transfer_code:, otp: }.compact,
        )
      end
    end

    # Successful response from calling #bulk.
    class BulkResponse < PaystackGateway::Response; end

    # Error response from #bulk.
    class BulkError < ApiError; end

    # https://paystack.com/docs/api/transfer/#bulk
    # Initiate Bulk Transfer: POST /transfer/bulk
    #
    # @param source [String] (required)
    #        Where should we transfer from? Only balance is allowed for now
    # @param transfers [Array<Hash>] (required)
    #        A list of transfer object. Each object should contain amount, recipient, and reference
    #
    # @return [BulkResponse] successful response
    # @raise [BulkError] if the request fails
    api_method def self.bulk(source:, transfers:)
      use_connection do |connection|
        connection.post(
          '/transfer/bulk',
          { source:, transfers: }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :amount,
               :createdAt,
               :currency,
               :domain,
               :failures,
               :id,
               :integration,
               :reason,
               :reference,
               :source,
               :source_details,
               :titan_code,
               :transfer_code,
               :request,
               :transferred_at,
               :updatedAt,
               :recipient,
               :session,
               :fee_charged,
               :fees_breakdown,
               :gateway_response, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/transfer/#fetch
    # Fetch Transfer: GET /transfer/{code}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/transfer/#{code}",
        )
      end
    end

    # Successful response from calling #verify.
    class VerifyResponse < PaystackGateway::Response
      delegate :amount,
               :createdAt,
               :currency,
               :domain,
               :failures,
               :id,
               :integration,
               :reason,
               :reference,
               :source,
               :source_details,
               :titan_code,
               :transfer_code,
               :transferred_at,
               :updatedAt,
               :recipient,
               :session,
               :gateway_response, to: :data
    end

    # Error response from #verify.
    class VerifyError < ApiError; end

    # https://paystack.com/docs/api/transfer/#verify
    # Verify Transfer: GET /transfer/verify/{reference}
    #
    # @param reference [String] (required)
    #
    # @return [VerifyResponse] successful response
    # @raise [VerifyError] if the request fails
    api_method def self.verify(reference:)
      use_connection do |connection|
        connection.get(
          "/transfer/verify/#{reference}",
        )
      end
    end

    # Successful response from calling #download.
    class DownloadResponse < PaystackGateway::Response; end

    # Error response from #download.
    class DownloadError < ApiError; end

    # https://paystack.com/docs/api/transfer/#download
    # Export Transfers: GET /transfer/export
    #
    # @param perPage [Integer]
    #        Number of records to fetch per page
    # @param page [Integer]
    #        The section to retrieve
    # @param status [String]
    # @param from [Time]
    #        The start date
    # @param to [Time]
    #        The end date
    #
    # @return [DownloadResponse] successful response
    # @raise [DownloadError] if the request fails
    api_method def self.download(per_page: nil, page: nil, status: nil, from: nil, to: nil)
      use_connection do |connection|
        connection.get(
          '/transfer/export',
          { perPage:, page:, status:, from:, to: }.compact,
        )
      end
    end

    # Successful response from calling #resend_otp.
    class ResendOtpResponse < PaystackGateway::Response; end

    # Error response from #resend_otp.
    class ResendOtpError < ApiError; end

    # https://paystack.com/docs/api/transfer/#resend_otp
    # Resend OTP for Transfer: POST /transfer/resend_otp
    #
    # @param transfer_code [String] (required)
    #        The transfer code that requires an OTP validation
    # @param reason [String] (required)
    #        Either resend_otp or transfer
    #
    # @return [ResendOtpResponse] successful response
    # @raise [ResendOtpError] if the request fails
    api_method def self.resend_otp(transfer_code:, reason:)
      use_connection do |connection|
        connection.post(
          '/transfer/resend_otp',
          { transfer_code:, reason: }.compact,
        )
      end
    end

    # Successful response from calling #disable_otp.
    class DisableOtpResponse < PaystackGateway::Response; end

    # Error response from #disable_otp.
    class DisableOtpError < ApiError; end

    # https://paystack.com/docs/api/transfer/#disable_otp
    # Disable OTP requirement for Transfers: POST /transfer/disable_otp
    #
    #
    # @return [DisableOtpResponse] successful response
    # @raise [DisableOtpError] if the request fails
    api_method def self.disable_otp
      use_connection do |connection|
        connection.post(
          '/transfer/disable_otp',
        )
      end
    end

    # Successful response from calling #disable_otp_finalize.
    class DisableOtpFinalizeResponse < PaystackGateway::Response; end

    # Error response from #disable_otp_finalize.
    class DisableOtpFinalizeError < ApiError; end

    # https://paystack.com/docs/api/transfer/#disable_otp_finalize
    # Finalize Disabling of OTP requirement for Transfers: POST /transfer/disable_otp_finalize
    #
    # @param otp [String] (required)
    #        OTP sent to business phone to verify disabling OTP requirement
    #
    # @return [DisableOtpFinalizeResponse] successful response
    # @raise [DisableOtpFinalizeError] if the request fails
    api_method def self.disable_otp_finalize(otp:)
      use_connection do |connection|
        connection.post(
          '/transfer/disable_otp_finalize',
          { otp: }.compact,
        )
      end
    end

    # Successful response from calling #enable_otp.
    class EnableOtpResponse < PaystackGateway::Response; end

    # Error response from #enable_otp.
    class EnableOtpError < ApiError; end

    # https://paystack.com/docs/api/transfer/#enable_otp
    # Enable OTP requirement for Transfers: POST /transfer/enable_otp
    #
    #
    # @return [EnableOtpResponse] successful response
    # @raise [EnableOtpError] if the request fails
    api_method def self.enable_otp
      use_connection do |connection|
        connection.post(
          '/transfer/enable_otp',
        )
      end
    end
  end
end
