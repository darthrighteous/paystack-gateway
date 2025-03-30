# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/split
  #
  # Transaction Splits
  # A collection of endpoints for spliting a transaction and managing the splits
  module Split
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/split/#list
    # List/Search Splits: GET /split
    #
    # @param name [String]
    # @param active [String]
    # @param sort_by [String]
    # @param from [String]
    # @param to [String]
    # @param perPage [String]
    # @param page [String]
    #
    # @return [ListResponse] successful response
    # @raise [ListError] if the request fails
    api_method def self.list(
      name: nil,
      active: nil,
      sort_by: nil,
      from: nil,
      to: nil,
      per_page: nil,
      page: nil
    )
      use_connection do |connection|
        connection.get(
          '/split',
          {
            name:,
            active:,
            sort_by:,
            from:,
            to:,
            perPage: per_page,
            page:,
          }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :id,
               :name,
               :type,
               :currency,
               :integration,
               :domain,
               :split_code,
               :active,
               :bearer_type,
               :bearer_subaccount,
               :createdAt,
               :updatedAt,
               :is_dynamic,
               :subaccounts,
               :total_subaccounts, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/split/#create
    # Create Split: POST /split
    #
    # @param name [String] (required)
    #        Name of the transaction split
    # @param type ["percentage", "flat"] (required)
    #        The type of transaction split you want to create.
    # @param subaccounts [Array<Hash>] (required)
    #        A list of object containing subaccount code and number of shares
    # @param currency ["NGN", "GHS", "ZAR", "USD"] (required)
    #        The transaction currency
    # @param bearer_type ["subaccount", "account", "all-proportional", "all"]
    #        This allows you specify how the transaction charge should be processed
    # @param bearer_subaccount [String]
    #        This is the subaccount code of the customer or partner that would bear the transaction
    #        charge if you specified subaccount as the bearer type
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(
      name:,
      type:,
      subaccounts:,
      currency:,
      bearer_type: nil,
      bearer_subaccount: nil
    )
      use_connection do |connection|
        connection.post(
          '/split',
          {
            name:,
            type:,
            subaccounts:,
            currency:,
            bearer_type:,
            bearer_subaccount:,
          }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :id,
               :name,
               :type,
               :currency,
               :integration,
               :domain,
               :split_code,
               :active,
               :bearer_type,
               :bearer_subaccount,
               :createdAt,
               :updatedAt,
               :is_dynamic,
               :subaccounts,
               :total_subaccounts, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/split/#fetch
    # Fetch Split: GET /split/{id}
    #
    # @param id [String] (required)
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch(id:)
      use_connection do |connection|
        connection.get(
          "/split/#{id}",
        )
      end
    end

    # Successful response from calling #update.
    class UpdateResponse < PaystackGateway::Response
      delegate :id,
               :name,
               :type,
               :currency,
               :integration,
               :domain,
               :split_code,
               :active,
               :bearer_type,
               :bearer_subaccount,
               :createdAt,
               :updatedAt,
               :is_dynamic,
               :subaccounts,
               :total_subaccounts, to: :data
    end

    # Error response from #update.
    class UpdateError < ApiError; end

    # https://paystack.com/docs/api/split/#update
    # Update Split: PUT /split/{id}
    #
    # @param id [String] (required)
    # @param name [String] (required)
    #        Name of the transaction split
    # @param active [Boolean] (required)
    #        Toggle status of split. When true, the split is active, else it's inactive
    # @param bearer_type ["subaccount", "account", "all-proportional", "all"] (required)
    #        This allows you specify how the transaction charge should be processed
    # @param bearer_subaccount [String] (required)
    #        This is the subaccount code of the customer or partner that would bear the transaction
    #        charge if you specified subaccount as the bearer type
    #
    # @return [UpdateResponse] successful response
    # @raise [UpdateError] if the request fails
    api_method def self.update(id:, name:, active:, bearer_type:, bearer_subaccount:)
      use_connection do |connection|
        connection.put(
          "/split/#{id}",
          { name:, active:, bearer_type:, bearer_subaccount: }.compact,
        )
      end
    end

    # Successful response from calling #add_subaccount.
    class AddSubaccountResponse < PaystackGateway::Response
      delegate :id,
               :name,
               :type,
               :currency,
               :integration,
               :domain,
               :split_code,
               :active,
               :bearer_type,
               :bearer_subaccount,
               :createdAt,
               :updatedAt,
               :is_dynamic,
               :subaccounts,
               :total_subaccounts, to: :data
    end

    # Error response from #add_subaccount.
    class AddSubaccountError < ApiError; end

    # https://paystack.com/docs/api/split/#add_subaccount
    # Add Subaccount to Split: POST /split/{id}/subaccount/add
    #
    # @param id [String] (required)
    # @param subaccount [String] (required)
    #        Subaccount code of the customer or partner
    # @param share [String] (required)
    #        The percentage or flat quota of the customer or partner
    #
    # @return [AddSubaccountResponse] successful response
    # @raise [AddSubaccountError] if the request fails
    api_method def self.add_subaccount(id:, subaccount:, share:)
      use_connection do |connection|
        connection.post(
          "/split/#{id}/subaccount/add",
          { subaccount:, share: }.compact,
        )
      end
    end

    # Successful response from calling #remove_subaccount.
    class RemoveSubaccountResponse < PaystackGateway::Response; end

    # Error response from #remove_subaccount.
    class RemoveSubaccountError < ApiError; end

    # https://paystack.com/docs/api/split/#remove_subaccount
    # Remove Subaccount from split: POST /split/{id}/subaccount/remove
    #
    # @param id [String] (required)
    # @param subaccount [String] (required)
    #        Subaccount code of the customer or partner
    # @param share [String] (required)
    #        The percentage or flat quota of the customer or partner
    #
    # @return [RemoveSubaccountResponse] successful response
    # @raise [RemoveSubaccountError] if the request fails
    api_method def self.remove_subaccount(id:, subaccount:, share:)
      use_connection do |connection|
        connection.post(
          "/split/#{id}/subaccount/remove",
          { subaccount:, share: }.compact,
        )
      end
    end
  end
end
