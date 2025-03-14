# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/dispute
  #
  # Disputes
  # A collection of endpoints for managing transactions complaint made by customers
  module Dispute
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/dispute/#list
    # List Disputes: GET /dispute
    #
    # @param perPage [Integer]
    #        Number of records to fetch per page
    # @param page [Integer]
    #        The section to retrieve
    # @param status [String]
    #        Dispute Status. Acceptable values are awaiting-merchant-feedback, awaiting-bank-feedback,
    #        pending, resolved
    # @param transaction [String]
    #        Transaction ID
    # @param from [Time]
    #        The start date
    # @param to [Time]
    #        The end date
    #
    # @return [ListResponse] successful response
    # @raise [ListError] if the request fails
    api_method def self.list(
      per_page: nil,
      page: nil,
      status: nil,
      transaction: nil,
      from: nil,
      to: nil
    )
      use_connection do |connection|
        connection.get(
          '/dispute',
          {
            perPage: per_page,
            page:,
            status:,
            transaction:,
            from:,
            to:,
          }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :id,
               :refund_amount,
               :currency,
               :resolution,
               :domain,
               :transaction,
               :transaction_reference,
               :category,
               :customer,
               :bin,
               :last4,
               :dueAt,
               :resolvedAt,
               :evidence,
               :attachments,
               :note,
               :history,
               :messages,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/dispute/#fetch
    # Fetch Dispute: GET /dispute/{id}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/dispute/#{id}",
        )
      end
    end

    # Successful response from calling #update.
    class UpdateResponse < PaystackGateway::Response
      delegate :id,
               :refund_amount,
               :currency,
               :resolution,
               :domain,
               :transaction,
               :transaction_reference,
               :category,
               :customer,
               :bin,
               :last4,
               :dueAt,
               :resolvedAt,
               :evidence,
               :attachments,
               :note,
               :history,
               :messages,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #update.
    class UpdateError < ApiError; end

    # https://paystack.com/docs/api/dispute/#update
    # Update Dispute: PUT /dispute/{id}
    #
    # @param refund_amount [String] (required)
    #        The amount to refund, in kobo if currency is NGN, pesewas, if currency is GHS, and
    #        cents, if currency is ZAR
    # @param uploaded_filename [String]
    #        Filename of attachment returned via response from the Dispute upload URL
    #
    # @return [UpdateResponse] successful response
    # @raise [UpdateError] if the request fails
    api_method def self.update(refund_amount:, uploaded_filename: nil)
      use_connection do |connection|
        connection.put(
          "/dispute/#{id}",
          { refund_amount:, uploaded_filename: }.compact,
        )
      end
    end

    # Successful response from calling #upload_url.
    class UploadUrlResponse < PaystackGateway::Response
      delegate :signedUrl, :fileName, to: :data
    end

    # Error response from #upload_url.
    class UploadUrlError < ApiError; end

    # https://paystack.com/docs/api/dispute/#upload_url
    # Get Upload URL: GET /dispute/{id}/upload_url
    #
    # @param id [String] (required)
    #        Dispute ID
    #
    # @return [UploadUrlResponse] successful response
    # @raise [UploadUrlError] if the request fails
    api_method def self.upload_url(id:)
      use_connection do |connection|
        connection.get(
          "/dispute/#{id}/upload_url",
        )
      end
    end

    # Successful response from calling #download.
    class DownloadResponse < PaystackGateway::Response
      delegate :path, :expiresAt, to: :data
    end

    # Error response from #download.
    class DownloadError < ApiError; end

    # https://paystack.com/docs/api/dispute/#download
    # Export Disputes: GET /dispute/export
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
          '/dispute/export',
          { perPage:, page:, status:, from:, to: }.compact,
        )
      end
    end

    # Successful response from calling #transaction.
    class TransactionResponse < PaystackGateway::Response
      delegate :history,
               :messages,
               :currency,
               :last4,
               :bin,
               :transaction_reference,
               :merchant_transaction_reference,
               :refund_amount,
               :domain,
               :resolution,
               :category,
               :note,
               :attachments,
               :id,
               :integration,
               :transaction,
               :created_by,
               :evidence,
               :resolvedAt,
               :createdAt,
               :updatedAt,
               :dueAt, to: :data
    end

    # Error response from #transaction.
    class TransactionError < ApiError; end

    # https://paystack.com/docs/api/dispute/#transaction
    # List Transaction Disputes: GET /dispute/transaction/{id}
    #
    # @param id [String] (required)
    #        Transaction ID
    #
    # @return [TransactionResponse] successful response
    # @raise [TransactionError] if the request fails
    api_method def self.transaction(id:)
      use_connection do |connection|
        connection.get(
          "/dispute/transaction/#{id}",
        )
      end
    end

    # Successful response from calling #resolve.
    class ResolveResponse < PaystackGateway::Response
      delegate :currency,
               :last4,
               :bin,
               :transaction_reference,
               :merchant_transaction_reference,
               :refund_amount,
               :domain,
               :resolution,
               :category,
               :note,
               :attachments,
               :id,
               :integration,
               :transaction,
               :created_by,
               :evidence,
               :resolvedAt,
               :createdAt,
               :updatedAt,
               :dueAt, to: :data
    end

    # Error response from #resolve.
    class ResolveError < ApiError; end

    # https://paystack.com/docs/api/dispute/#resolve
    # Resolve a Dispute: PUT /dispute/{id}/resolve
    #
    # @param id [String] (required)
    #        Dispute ID
    # @param resolution [String] (required)
    #        Dispute resolution. Accepted values, merchant-accepted, declined
    # @param message [String] (required)
    #        Reason for resolving
    # @param refund_amount [String] (required)
    #        The amount to refund, in kobo if currency is NGN, pesewas, if currency is GHS, and
    #        cents, if currency is ZAR
    # @param uploaded_filename [String] (required)
    #        Filename of attachment returned via response from the Dispute upload URL
    # @param evidence [Integer]
    #        Evidence Id for fraud claims
    #
    # @return [ResolveResponse] successful response
    # @raise [ResolveError] if the request fails
    api_method def self.resolve(
      id:,
      resolution:,
      message:,
      refund_amount:,
      uploaded_filename:,
      evidence: nil
    )
      use_connection do |connection|
        connection.put(
          "/dispute/#{id}/resolve",
          { resolution:, message:, refund_amount:, uploaded_filename:, evidence: }.compact,
        )
      end
    end

    # Successful response from calling #evidence.
    class EvidenceResponse < PaystackGateway::Response
      delegate :customer_email,
               :customer_name,
               :customer_phone,
               :service_details,
               :delivery_address,
               :delivery_date,
               :dispute,
               :id,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #evidence.
    class EvidenceError < ApiError; end

    # https://paystack.com/docs/api/dispute/#evidence
    # Add Evidence: POST /dispute/{id}/evidence
    #
    # @param id [String] (required)
    #        Dispute ID
    # @param customer_email [String] (required)
    #        Customer email
    # @param customer_name [String] (required)
    #        Customer name
    # @param customer_phone [String] (required)
    #        Customer mobile number
    # @param service_details [String] (required)
    #        Details of service offered
    # @param delivery_address [String]
    #        Delivery address
    # @param delivery_date [Time]
    #        ISO 8601 representation of delivery date (YYYY-MM-DD)
    #
    # @return [EvidenceResponse] successful response
    # @raise [EvidenceError] if the request fails
    api_method def self.evidence(
      id:,
      customer_email:,
      customer_name:,
      customer_phone:,
      service_details:,
      delivery_address: nil,
      delivery_date: nil
    )
      use_connection do |connection|
        connection.post(
          "/dispute/#{id}/evidence",
          {
            customer_email:,
            customer_name:,
            customer_phone:,
            service_details:,
            delivery_address:,
            delivery_date:,
          }.compact,
        )
      end
    end
  end
end
