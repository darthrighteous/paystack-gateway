# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/transferrecipient
  #
  # Transfer Recipients
  # A collection of endpoints for creating and managing beneficiaries that you send money to
  module TransferRecipient
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/transfer-recipient/#list
    # List Transfer Recipients: GET /transferrecipient
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
          '/transferrecipient',
          { perPage: per_page, page:, from:, to: }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :active,
               :createdAt,
               :currency,
               :description,
               :domain,
               :email,
               :id,
               :integration,
               :metadata,
               :name,
               :recipient_code,
               :type,
               :updatedAt,
               :is_deleted,
               :isDeleted,
               :details, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/transfer-recipient/#create
    # Create Transfer Recipient: POST /transferrecipient
    #
    # @param type [String] (required)
    #        Recipient Type (Only nuban at this time)
    # @param name [String] (required)
    #        Recipient's name
    # @param account_number [String] (required)
    #        Recipient's bank account number
    # @param bank_code [String] (required)
    #        Recipient's bank code. You can get the list of Bank Codes by calling the List Banks
    #        endpoint
    # @param description [String]
    #        A description for this recipient
    # @param currency [String]
    #        Currency for the account receiving the transfer
    # @param authorization_code [String]
    #        An authorization code from a previous transaction
    # @param metadata [String]
    #        Stringified JSON object of custom data
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(
      type:,
      name:,
      account_number:,
      bank_code:,
      description: nil,
      currency: nil,
      authorization_code: nil,
      metadata: nil
    )
      use_connection do |connection|
        connection.post(
          '/transferrecipient',
          {
            type:,
            name:,
            account_number:,
            bank_code:,
            description:,
            currency:,
            authorization_code:,
            metadata:,
          }.compact,
        )
      end
    end

    # Successful response from calling #bulk.
    class BulkResponse < PaystackGateway::Response
      delegate :success, :errors, to: :data
    end

    # Error response from #bulk.
    class BulkError < ApiError; end

    # https://paystack.com/docs/api/transfer-recipient/#bulk
    # Bulk Create Transfer Recipient: POST /transferrecipient/bulk
    #
    # @param batch [Array<Hash>] (required)
    #        A list of transfer recipient object. Each object should contain type, name, and
    #        bank_code. Any Create Transfer Recipient param can also be passed.
    #
    # @return [BulkResponse] successful response
    # @raise [BulkError] if the request fails
    api_method def self.bulk(batch:)
      use_connection do |connection|
        connection.post(
          '/transferrecipient/bulk',
          { batch: }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :integration,
               :domain,
               :type,
               :currency,
               :name,
               :details,
               :description,
               :metadata,
               :recipient_code,
               :active,
               :recipient_account,
               :institution_code,
               :email,
               :id,
               :isDeleted,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/transfer-recipient/#fetch
    # Fetch Transfer recipient: GET /transferrecipient/{code}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/transferrecipient/#{code}",
        )
      end
    end

    # Successful response from calling #update.
    class UpdateResponse < PaystackGateway::Response; end

    # Error response from #update.
    class UpdateError < ApiError; end

    # https://paystack.com/docs/api/transfer-recipient/#update
    # Update Transfer recipient: PUT /transferrecipient/{code}
    #
    # @param name [String] (required)
    #        Recipient's name
    # @param email [String] (required)
    #        Recipient's email address
    #
    # @return [UpdateResponse] successful response
    # @raise [UpdateError] if the request fails
    api_method def self.update(name:, email:)
      use_connection do |connection|
        connection.put(
          "/transferrecipient/#{code}",
          { name:, email: }.compact,
        )
      end
    end

    # Successful response from calling #delete.
    class DeleteResponse < PaystackGateway::Response; end

    # Error response from #delete.
    class DeleteError < ApiError; end

    # https://paystack.com/docs/api/transfer-recipient/#delete
    # Delete Transfer Recipient: DELETE /transferrecipient/{code}
    #
    #
    # @return [DeleteResponse] successful response
    # @raise [DeleteError] if the request fails
    api_method def self.delete
      use_connection do |connection|
        connection.delete(
          "/transferrecipient/#{code}",
        )
      end
    end
  end
end
