# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/dedicatedvirtualaccount
  #
  # Dedicated Virtual Accounts
  # A collection of endpoints for creating and managing payment accounts for customers
  module DedicatedVirtualAccount
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response
      delegate :customer,
               :bank,
               :id,
               :account_name,
               :account_number,
               :created_at,
               :updated_at,
               :currency,
               :split_config,
               :active,
               :assigned, to: :data
    end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/dedicated-virtual-account/#list
    # List Dedicated Accounts: GET /dedicated_account
    #
    # @param account_number [String]
    # @param customer [String]
    # @param active [Boolean]
    # @param currency [String]
    # @param provider_slug [String]
    # @param bank_id [String]
    # @param perPage [String]
    # @param page [String]
    #
    # @return [ListResponse] successful response
    # @raise [ListError] if the request fails
    api_method def self.list(
      account_number: nil,
      customer: nil,
      active: nil,
      currency: nil,
      provider_slug: nil,
      bank_id: nil,
      per_page: nil,
      page: nil
    )
      use_connection do |connection|
        connection.get(
          '/dedicated_account',
          {
            account_number:,
            customer:,
            active:,
            currency:,
            provider_slug:,
            bank_id:,
            perPage: per_page,
            page:,
          }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :bank,
               :account_name,
               :account_number,
               :assigned,
               :currency,
               :metadata,
               :active,
               :id,
               :created_at,
               :updated_at,
               :assignment,
               :customer, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/dedicated-virtual-account/#create
    # Create Dedicated Account: POST /dedicated_account
    #
    # @param customer [String] (required)
    #        Customer ID or code
    # @param preferred_bank [String]
    #        The bank slug for preferred bank. To get a list of available banks, use the List
    #        Providers endpoint
    # @param subaccount [String]
    #        Subaccount code of the account you want to split the transaction with
    # @param split_code [String]
    #        Split code consisting of the lists of accounts you want to split the transaction
    #        with
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(customer:, preferred_bank: nil, subaccount: nil, split_code: nil)
      use_connection do |connection|
        connection.post(
          '/dedicated_account',
          { customer:, preferred_bank:, subaccount:, split_code: }.compact,
        )
      end
    end

    # Successful response from calling #assign.
    class AssignResponse < PaystackGateway::Response; end

    # Error response from #assign.
    class AssignError < ApiError; end

    # https://paystack.com/docs/api/dedicated-virtual-account/#assign
    # Assign Dedicated Account: POST /dedicated_account/assign
    #
    # @param email [String] (required)
    #        Customer's email address
    # @param first_name [String] (required)
    #        Customer's first name
    # @param last_name [String] (required)
    #        Customer's last name
    # @param phone [String] (required)
    #        Customer's phone name
    # @param preferred_bank [String] (required)
    #        The bank slug for preferred bank. To get a list of available banks, use the List
    #        Banks endpoint, passing `pay_with_bank_transfer=true` query parameter
    # @param country [String] (required)
    #        Currently accepts NG only
    # @param account_number [String]
    #        Customer's account number
    # @param bvn [String]
    #        Customer's Bank Verification Number
    # @param bank_code [String]
    #        Customer's bank code
    # @param subaccount [String]
    #        Subaccount code of the account you want to split the transaction with
    # @param split_code [String]
    #        Split code consisting of the lists of accounts you want to split the transaction
    #        with
    #
    # @return [AssignResponse] successful response
    # @raise [AssignError] if the request fails
    api_method def self.assign(
      email:,
      first_name:,
      last_name:,
      phone:,
      preferred_bank:,
      country:,
      account_number: nil,
      bvn: nil,
      bank_code: nil,
      subaccount: nil,
      split_code: nil
    )
      use_connection do |connection|
        connection.post(
          '/dedicated_account/assign',
          {
            email:,
            first_name:,
            last_name:,
            phone:,
            preferred_bank:,
            country:,
            account_number:,
            bvn:,
            bank_code:,
            subaccount:,
            split_code:,
          }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :customer,
               :bank,
               :id,
               :account_name,
               :account_number,
               :created_at,
               :updated_at,
               :currency,
               :split_config,
               :active,
               :assigned, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/dedicated-virtual-account/#fetch
    # Fetch Dedicated Account: GET /dedicated_account/{account_id}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/dedicated_account/#{account_id}",
        )
      end
    end

    # Successful response from calling #deactivate.
    class DeactivateResponse < PaystackGateway::Response
      delegate :bank,
               :account_name,
               :account_number,
               :assigned,
               :currency,
               :metadata,
               :active,
               :id,
               :created_at,
               :updated_at,
               :assignment, to: :data
    end

    # Error response from #deactivate.
    class DeactivateError < ApiError; end

    # https://paystack.com/docs/api/dedicated-virtual-account/#deactivate
    # Deactivate Dedicated Account: DELETE /dedicated_account/{account_id}
    #
    #
    # @return [DeactivateResponse] successful response
    # @raise [DeactivateError] if the request fails
    api_method def self.deactivate
      use_connection do |connection|
        connection.delete(
          "/dedicated_account/#{account_id}",
        )
      end
    end

    # Successful response from calling #requery.
    class RequeryResponse < PaystackGateway::Response; end

    # Error response from #requery.
    class RequeryError < ApiError; end

    # https://paystack.com/docs/api/dedicated-virtual-account/#requery
    # Requery Dedicated Account: GET /dedicated_account/requery
    #
    #
    # @return [RequeryResponse] successful response
    # @raise [RequeryError] if the request fails
    api_method def self.requery
      use_connection do |connection|
        connection.get(
          '/dedicated_account/requery',
        )
      end
    end

    # Successful response from calling #add_split.
    class AddSplitResponse < PaystackGateway::Response; end

    # Error response from #add_split.
    class AddSplitError < ApiError; end

    # https://paystack.com/docs/api/dedicated-virtual-account/#add_split
    # Split Dedicated Account Transaction: POST /dedicated_account/split
    #
    # @param account_number [String] (required)
    #        Valid Dedicated virtual account
    # @param subaccount [String]
    #        Subaccount code of the account you want to split the transaction with
    # @param split_code [String]
    #        Split code consisting of the lists of accounts you want to split the transaction
    #        with
    #
    # @return [AddSplitResponse] successful response
    # @raise [AddSplitError] if the request fails
    api_method def self.add_split(account_number:, subaccount: nil, split_code: nil)
      use_connection do |connection|
        connection.post(
          '/dedicated_account/split',
          { account_number:, subaccount:, split_code: }.compact,
        )
      end
    end

    # Successful response from calling #remove_split.
    class RemoveSplitResponse < PaystackGateway::Response; end

    # Error response from #remove_split.
    class RemoveSplitError < ApiError; end

    # https://paystack.com/docs/api/dedicated-virtual-account/#remove_split
    # Remove Split from Dedicated Account: DELETE /dedicated_account/split
    #
    # @param account_number [String] (required)
    #        Valid Dedicated virtual account
    # @param subaccount [String]
    #        Subaccount code of the account you want to split the transaction with
    # @param split_code [String]
    #        Split code consisting of the lists of accounts you want to split the transaction
    #        with
    #
    # @return [RemoveSplitResponse] successful response
    # @raise [RemoveSplitError] if the request fails
    api_method def self.remove_split(account_number:, subaccount: nil, split_code: nil)
      use_connection do |connection|
        connection.delete(
          '/dedicated_account/split',
          { account_number:, subaccount:, split_code: }.compact,
        )
      end
    end

    # Successful response from calling #available_providers.
    class AvailableProvidersResponse < PaystackGateway::Response; end

    # Error response from #available_providers.
    class AvailableProvidersError < ApiError; end

    # https://paystack.com/docs/api/dedicated-virtual-account/#available_providers
    # Fetch Bank Providers: GET /dedicated_account/available_providers
    #
    #
    # @return [AvailableProvidersResponse] successful response
    # @raise [AvailableProvidersError] if the request fails
    api_method def self.available_providers
      use_connection do |connection|
        connection.get(
          '/dedicated_account/available_providers',
        )
      end
    end
  end
end
