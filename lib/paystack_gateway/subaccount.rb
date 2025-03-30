# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/subaccount
  #
  # Subaccounts
  # A collection of endpoints for creating and managing accounts for sharing a transaction with
  module Subaccount
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/subaccount/#list
    # List Subaccounts: GET /subaccount
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
          '/subaccount',
          { perPage: per_page, page:, from:, to: }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :business_name,
               :description,
               :primary_contact_name,
               :primary_contact_email,
               :primary_contact_phone,
               :metadata,
               :account_number,
               :percentage_charge,
               :settlement_bank,
               :currency,
               :bank,
               :integration,
               :domain,
               :managed_by_integration,
               :product,
               :subaccount_code,
               :is_verified,
               :settlement_schedule,
               :active,
               :migrate,
               :id,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/subaccount/#create
    # Create Subaccount: POST /subaccount
    #
    # @param business_name [String] (required)
    #        Name of business for subaccount
    # @param settlement_bank [String] (required)
    #        Bank code for the bank. You can get the list of Bank Codes by calling the List Banks
    #        endpoint.
    # @param account_number [String] (required)
    #        Bank account number
    # @param percentage_charge [Number] (required)
    #        Customer's phone number
    # @param description [String]
    #        A description for this subaccount
    # @param primary_contact_email [String]
    #        A contact email for the subaccount
    # @param primary_contact_name [String]
    #        The name of the contact person for this subaccount
    # @param primary_contact_phone [String]
    #        A phone number to call for this subaccount
    # @param metadata [String]
    #        Stringified JSON object of custom data
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(
      business_name:,
      settlement_bank:,
      account_number:,
      percentage_charge:,
      description: nil,
      primary_contact_email: nil,
      primary_contact_name: nil,
      primary_contact_phone: nil,
      metadata: nil
    )
      use_connection do |connection|
        connection.post(
          '/subaccount',
          {
            business_name:,
            settlement_bank:,
            account_number:,
            percentage_charge:,
            description:,
            primary_contact_email:,
            primary_contact_name:,
            primary_contact_phone:,
            metadata:,
          }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :integration,
               :bank,
               :managed_by_integration,
               :domain,
               :subaccount_code,
               :business_name,
               :description,
               :primary_contact_name,
               :primary_contact_email,
               :primary_contact_phone,
               :metadata,
               :percentage_charge,
               :is_verified,
               :settlement_bank,
               :account_number,
               :settlement_schedule,
               :active,
               :migrate,
               :currency,
               :product,
               :id,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/subaccount/#fetch
    # Fetch Subaccount: GET /subaccount/{code}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/subaccount/#{code}",
        )
      end
    end

    # Successful response from calling #update.
    class UpdateResponse < PaystackGateway::Response
      delegate :domain,
               :subaccount_code,
               :business_name,
               :description,
               :primary_contact_name,
               :primary_contact_email,
               :primary_contact_phone,
               :metadata,
               :percentage_charge,
               :is_verified,
               :settlement_bank,
               :account_number,
               :settlement_schedule,
               :active,
               :migrate,
               :currency,
               :product,
               :id,
               :integration,
               :bank,
               :managed_by_integration,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #update.
    class UpdateError < ApiError; end

    # https://paystack.com/docs/api/subaccount/#update
    # Update Subaccount: PUT /subaccount/{code}
    #
    # @param business_name [String] (required)
    #        Name of business for subaccount
    # @param settlement_bank [String] (required)
    #        Bank code for the bank. You can get the list of Bank Codes by calling the List Banks
    #        endpoint.
    # @param account_number [String] (required)
    #        Bank account number
    # @param active [Boolean] (required)
    #        Activate or deactivate a subaccount
    # @param percentage_charge [Number] (required)
    #        Customer's phone number
    # @param description [String] (required)
    #        A description for this subaccount
    # @param primary_contact_email [String] (required)
    #        A contact email for the subaccount
    # @param primary_contact_name [String] (required)
    #        The name of the contact person for this subaccount
    # @param primary_contact_phone [String] (required)
    #        A phone number to call for this subaccount
    # @param metadata [String] (required)
    #        Stringified JSON object of custom data
    #
    # @return [UpdateResponse] successful response
    # @raise [UpdateError] if the request fails
    api_method def self.update(
      business_name:,
      settlement_bank:,
      account_number:,
      active:,
      percentage_charge:,
      description:,
      primary_contact_email:,
      primary_contact_name:,
      primary_contact_phone:,
      metadata:
    )
      use_connection do |connection|
        connection.put(
          "/subaccount/#{code}",
          {
            business_name:,
            settlement_bank:,
            account_number:,
            active:,
            percentage_charge:,
            description:,
            primary_contact_email:,
            primary_contact_name:,
            primary_contact_phone:,
            metadata:,
          }.compact,
        )
      end
    end
  end
end
