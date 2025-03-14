# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/page
  #
  # Payment Pages
  # A collection of endpoints for creating and managing links for the collection of payment for products
  module Page
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/page/#list
    # List Pages: GET /page
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
          '/page',
          { perPage:, page:, from:, to: }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :name,
               :integration,
               :domain,
               :slug,
               :currency,
               :type,
               :collect_phone,
               :active,
               :published,
               :migrate,
               :id,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/page/#create
    # Create Page: POST /page
    #
    # @param name [String] (required)
    #        Name of page
    # @param description [String]
    #        The description of the page
    # @param amount [Integer]
    #        Amount should be in kobo if currency is NGN, pesewas, if currency is GHS, and cents,
    #        if currency is ZAR
    # @param currency ["NGN", "GHS", "ZAR", "KES", "USD"]
    #        The transaction currency. Defaults to your integration currency.
    # @param slug [String]
    #        URL slug you would like to be associated with this page. Page will be accessible
    #        at `https://paystack.com/pay/[slug]`
    # @param type ["payment", "subscription", "product", "plan"]
    #        The type of payment page to create. Defaults to `payment` if no type is specified.
    # @param plan [String]
    #        The ID of the plan to subscribe customers on this payment page to when `type` is
    #        set to `subscription`.
    # @param fixed_amount [Boolean]
    #        Specifies whether to collect a fixed amount on the payment page. If true, `amount`
    #        must be passed.
    # @param split_code [String]
    #        The split code of the transaction split. e.g. `SPL_98WF13Eb3w`
    # @param metadata [String]
    #        Stringified JSON object of custom data
    # @param redirect_url [String]
    #        If you would like Paystack to redirect to a URL upon successful payment, specify
    #        the URL here.
    # @param success_message [String]
    #        A success message to display to the customer after a successful transaction
    # @param notification_email [String]
    #        An email address that will receive transaction notifications for this payment page
    # @param collect_phone [Boolean]
    #        Specify whether to collect phone numbers on the payment page
    # @param custom_fields [Array<Hash>]
    #        If you would like to accept custom fields, specify them here.
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(
      name:,
      description: nil,
      amount: nil,
      currency: nil,
      slug: nil,
      type: nil,
      plan: nil,
      fixed_amount: nil,
      split_code: nil,
      metadata: nil,
      redirect_url: nil,
      success_message: nil,
      notification_email: nil,
      collect_phone: nil,
      custom_fields: nil
    )
      use_connection do |connection|
        connection.post(
          '/page',
          {
            name:,
            description:,
            amount:,
            currency:,
            slug:,
            type:,
            plan:,
            fixed_amount:,
            split_code:,
            metadata:,
            redirect_url:,
            success_message:,
            notification_email:,
            collect_phone:,
            custom_fields:,
          }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :integration,
               :domain,
               :name,
               :description,
               :amount,
               :currency,
               :slug,
               :custom_fields,
               :type,
               :redirect_url,
               :success_message,
               :collect_phone,
               :active,
               :published,
               :migrate,
               :notification_email,
               :metadata,
               :split_code,
               :id,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/page/#fetch
    # Fetch Page: GET /page/{id}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/page/#{id}",
        )
      end
    end

    # Successful response from calling #update.
    class UpdateResponse < PaystackGateway::Response
      delegate :domain,
               :name,
               :description,
               :amount,
               :currency,
               :slug,
               :custom_fields,
               :type,
               :redirect_url,
               :success_message,
               :collect_phone,
               :active,
               :published,
               :migrate,
               :notification_email,
               :metadata,
               :split_code,
               :id,
               :integration,
               :plan,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #update.
    class UpdateError < ApiError; end

    # https://paystack.com/docs/api/page/#update
    # Update Page: PUT /page/{id}
    #
    # @param name [String] (required)
    #        Name of page
    # @param description [String] (required)
    #        The description of the page
    # @param amount [Integer] (required)
    #        Amount should be in kobo if currency is NGN, pesewas, if currency is GHS, and cents,
    #        if currency is ZAR
    # @param active [Boolean] (required)
    #        Set to false to deactivate page url
    #
    # @return [UpdateResponse] successful response
    # @raise [UpdateError] if the request fails
    api_method def self.update(name:, description:, amount:, active:)
      use_connection do |connection|
        connection.put(
          "/page/#{id}",
          { name:, description:, amount:, active: }.compact,
        )
      end
    end

    # Successful response from calling #check_slug_availability.
    class CheckSlugAvailabilityResponse < PaystackGateway::Response; end

    # Error response from #check_slug_availability.
    class CheckSlugAvailabilityError < ApiError; end

    # https://paystack.com/docs/api/page/#check_slug_availability
    # Check Slug Availability: GET /page/check_slug_availability/{slug}
    #
    #
    # @return [CheckSlugAvailabilityResponse] successful response
    # @raise [CheckSlugAvailabilityError] if the request fails
    api_method def self.check_slug_availability
      use_connection do |connection|
        connection.get(
          "/page/check_slug_availability/#{slug}",
        )
      end
    end

    # Successful response from calling #add_products.
    class AddProductsResponse < PaystackGateway::Response
      delegate :integration,
               :plan,
               :domain,
               :name,
               :description,
               :amount,
               :currency,
               :slug,
               :custom_fields,
               :type,
               :redirect_url,
               :success_message,
               :collect_phone,
               :active,
               :published,
               :migrate,
               :notification_email,
               :metadata,
               :split_code,
               :id,
               :createdAt,
               :updatedAt,
               :products, to: :data
    end

    # Error response from #add_products.
    class AddProductsError < ApiError; end

    # https://paystack.com/docs/api/page/#add_products
    # Add Products: POST /page/{id}/product
    #
    # @param product [Array<String>] (required)
    #        IDs of all products to add to a page
    #
    # @return [AddProductsResponse] successful response
    # @raise [AddProductsError] if the request fails
    api_method def self.add_products(product:)
      use_connection do |connection|
        connection.post(
          "/page/#{id}/product",
          { product: }.compact,
        )
      end
    end
  end
end
