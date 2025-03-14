# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/product
  #
  # Products
  # A collection of endpoints for creating and managing inventories
  module Product
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/product/#list
    # List Products: GET /product
    #
    # @param perPage [Integer]
    # @param page [Integer]
    # @param active [Boolean]
    # @param from [Time]
    #        The start date
    # @param to [Time]
    #        The end date
    #
    # @return [ListResponse] successful response
    # @raise [ListError] if the request fails
    api_method def self.list(per_page: nil, page: nil, active: nil, from: nil, to: nil)
      use_connection do |connection|
        connection.get(
          '/product',
          { perPage:, page:, active:, from:, to: }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :variants_options,
               :variants,
               :name,
               :description,
               :currency,
               :price,
               :quantity,
               :type,
               :is_shippable,
               :unlimited,
               :files,
               :shipping_fields,
               :integration,
               :domain,
               :metadata,
               :slug,
               :product_code,
               :quantity_sold,
               :active,
               :deleted_at,
               :in_stock,
               :minimum_orderable,
               :maximum_orderable,
               :low_stock_alert,
               :id,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/product/#create
    # Create Product: POST /product
    #
    # @param name [String] (required)
    #        Name of product
    # @param description [String] (required)
    #        The description of the product
    # @param price [Integer] (required)
    #        Price should be in kobo if currency is NGN, pesewas, if currency is GHS, and cents,
    #        if currency is ZAR
    # @param currency [String] (required)
    #        Currency in which price is set. Allowed values are: NGN, GHS, ZAR or USD
    # @param unlimited [Boolean]
    #        Set to true if the product has unlimited stock. Leave as false if the product has
    #        limited stock
    # @param quantity [Integer]
    #        Number of products in stock. Use if limited is true
    # @param split_code [String]
    #        The split code if sharing the transaction with partners
    # @param metadata [String]
    #        Stringified JSON object of custom data
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(
      name:,
      description:,
      price:,
      currency:,
      unlimited: nil,
      quantity: nil,
      split_code: nil,
      metadata: nil
    )
      use_connection do |connection|
        connection.post(
          '/product',
          {
            name:,
            description:,
            price:,
            currency:,
            unlimited:,
            quantity:,
            split_code:,
            metadata:,
          }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :digital_assets,
               :integration,
               :name,
               :description,
               :product_code,
               :price,
               :currency,
               :quantity,
               :quantity_sold,
               :type,
               :files,
               :file_path,
               :is_shippable,
               :shipping_fields,
               :unlimited,
               :domain,
               :active,
               :features,
               :in_stock,
               :metadata,
               :slug,
               :success_message,
               :redirect_url,
               :split_code,
               :notification_emails,
               :minimum_orderable,
               :maximum_orderable,
               :low_stock_alert,
               :stock_threshold,
               :expires_in,
               :id,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/product/#fetch
    # Fetch Product: GET /product/{id}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/product/#{id}",
        )
      end
    end

    # Successful response from calling #update.
    class UpdateResponse < PaystackGateway::Response
      delegate :name,
               :description,
               :product_code,
               :price,
               :currency,
               :quantity,
               :quantity_sold,
               :type,
               :files,
               :file_path,
               :is_shippable,
               :shipping_fields,
               :unlimited,
               :domain,
               :active,
               :features,
               :in_stock,
               :metadata,
               :slug,
               :success_message,
               :redirect_url,
               :split_code,
               :notification_emails,
               :minimum_orderable,
               :maximum_orderable,
               :low_stock_alert,
               :stock_threshold,
               :expires_in,
               :id,
               :integration,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #update.
    class UpdateError < ApiError; end

    # https://paystack.com/docs/api/product/#update
    # Update product: PUT /product/{id}
    #
    # @param name [String] (required)
    #        Name of product
    # @param description [String] (required)
    #        The description of the product
    # @param price [Integer] (required)
    #        Price should be in kobo if currency is NGN, pesewas, if currency is GHS, and cents,
    #        if currency is ZAR
    # @param currency [String] (required)
    #        Currency in which price is set. Allowed values are: NGN, GHS, ZAR or USD
    # @param unlimited [Boolean] (required)
    #        Set to true if the product has unlimited stock. Leave as false if the product has
    #        limited stock
    # @param quantity [Integer] (required)
    #        Number of products in stock. Use if limited is true
    # @param split_code [String] (required)
    #        The split code if sharing the transaction with partners
    # @param metadata [String] (required)
    #        Stringified JSON object of custom data
    #
    # @return [UpdateResponse] successful response
    # @raise [UpdateError] if the request fails
    api_method def self.update(
      name:,
      description:,
      price:,
      currency:,
      unlimited:,
      quantity:,
      split_code:,
      metadata:
    )
      use_connection do |connection|
        connection.put(
          "/product/#{id}",
          {
            name:,
            description:,
            price:,
            currency:,
            unlimited:,
            quantity:,
            split_code:,
            metadata:,
          }.compact,
        )
      end
    end

    # Successful response from calling #delete.
    class DeleteResponse < PaystackGateway::Response; end

    # Error response from #delete.
    class DeleteError < ApiError; end

    # https://paystack.com/docs/api/product/#delete
    # Delete Product: DELETE /product/{id}
    #
    #
    # @return [DeleteResponse] successful response
    # @raise [DeleteError] if the request fails
    api_method def self.delete
      use_connection do |connection|
        connection.delete(
          "/product/#{id}",
        )
      end
    end
  end
end
