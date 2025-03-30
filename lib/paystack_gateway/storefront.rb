# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/storefront
  #
  # Storefronts
  # A collection of endpoints for creating and managing storefronts
  module Storefront
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/storefront/#list
    # List Storefronts: GET /storefront
    #
    # @param perPage [Integer]
    # @param page [Integer]
    # @param status ["active", "inactive"]
    #
    # @return [ListResponse] successful response
    # @raise [ListError] if the request fails
    api_method def self.list(per_page: nil, page: nil, status: nil)
      use_connection do |connection|
        connection.get(
          '/storefront',
          { perPage: per_page, page:, status: }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :social_media,
               :contacts,
               :name,
               :slug,
               :currency,
               :welcome_message,
               :success_message,
               :redirect_url,
               :description,
               :delivery_note,
               :background_color,
               :shippable,
               :integration,
               :domain,
               :digital_product_expiry,
               :id,
               :createdAt,
               :updatedAt,
               :products,
               :shipping_fees, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/storefront/#create
    # Create Storefront: POST /storefront
    #
    # @param name [String] (required)
    #        Name of the storefront
    # @param slug [String] (required)
    #        A unique identifier to access your store. Once the storefront is created, it can
    #        be accessed from https://paystack.shop/your-slug
    # @param currency [String] (required)
    #        Currency for prices of products in your storefront. Allowed values are: `NGN`, `GHS`,
    #        `KES`, `ZAR` or `USD`
    # @param description [String]
    #        The description of the storefront
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(name:, slug:, currency:, description: nil)
      use_connection do |connection|
        connection.post(
          '/storefront',
          { name:, slug:, currency:, description: }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :social_media,
               :contacts,
               :name,
               :slug,
               :currency,
               :welcome_message,
               :success_message,
               :redirect_url,
               :description,
               :delivery_note,
               :background_color,
               :shippable,
               :integration,
               :domain,
               :digital_product_expiry,
               :id,
               :createdAt,
               :updatedAt,
               :products,
               :shipping_fees, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/storefront/#fetch
    # Fetch Storefront: GET /storefront/{id}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/storefront/#{id}",
        )
      end
    end

    # Successful response from calling #update.
    class UpdateResponse < PaystackGateway::Response; end

    # Error response from #update.
    class UpdateError < ApiError; end

    # https://paystack.com/docs/api/storefront/#update
    # Update Storefront: PUT /storefront/{id}
    #
    # @param name [String] (required)
    #        Name of the storefront
    # @param slug [String] (required)
    #        A unique identifier to access your store. Once the storefront is created, it can
    #        be accessed from https://paystack.shop/your-slug
    # @param description [String] (required)
    #        The description of the storefront
    #
    # @return [UpdateResponse] successful response
    # @raise [UpdateError] if the request fails
    api_method def self.update(name:, slug:, description:)
      use_connection do |connection|
        connection.put(
          "/storefront/#{id}",
          { name:, slug:, description: }.compact,
        )
      end
    end

    # Successful response from calling #delete.
    class DeleteResponse < PaystackGateway::Response; end

    # Error response from #delete.
    class DeleteError < ApiError; end

    # https://paystack.com/docs/api/storefront/#delete
    # Delete Storefront: DELETE /storefront/{id}
    #
    #
    # @return [DeleteResponse] successful response
    # @raise [DeleteError] if the request fails
    api_method def self.delete
      use_connection do |connection|
        connection.delete(
          "/storefront/#{id}",
        )
      end
    end

    # Successful response from calling #verify_slug.
    class VerifySlugResponse < PaystackGateway::Response; end

    # Error response from #verify_slug.
    class VerifySlugError < ApiError; end

    # https://paystack.com/docs/api/storefront/#verify_slug
    # Verify Storefront Slug: GET /storefront/verify/{slug}
    #
    #
    # @return [VerifySlugResponse] successful response
    # @raise [VerifySlugError] if the request fails
    api_method def self.verify_slug
      use_connection do |connection|
        connection.get(
          "/storefront/verify/#{slug}",
        )
      end
    end

    # Successful response from calling #fetch_orders.
    class FetchOrdersResponse < PaystackGateway::Response; end

    # Error response from #fetch_orders.
    class FetchOrdersError < ApiError; end

    # https://paystack.com/docs/api/storefront/#fetch_orders
    # Fetch Storefront Orders: GET /storefront/{id}/order
    # Fetch all orders in your Storefront
    #
    # @param id [String] (required)
    #
    # @return [FetchOrdersResponse] successful response
    # @raise [FetchOrdersError] if the request fails
    api_method def self.fetch_orders(id:)
      use_connection do |connection|
        connection.get(
          "/storefront/#{id}/order",
        )
      end
    end

    # Successful response from calling #list_products.
    class ListProductsResponse < PaystackGateway::Response; end

    # Error response from #list_products.
    class ListProductsError < ApiError; end

    # https://paystack.com/docs/api/storefront/#list_products
    # List Products in Storefront: GET /storefront/{id}/product
    #
    #
    # @return [ListProductsResponse] successful response
    # @raise [ListProductsError] if the request fails
    api_method def self.list_products
      use_connection do |connection|
        connection.get(
          "/storefront/#{id}/product",
        )
      end
    end

    # Successful response from calling #add_products.
    class AddProductsResponse < PaystackGateway::Response; end

    # Error response from #add_products.
    class AddProductsError < ApiError; end

    # https://paystack.com/docs/api/storefront/#add_products
    # Add Products to Storefront: POST /storefront/{id}/product
    #
    # @param products [Array<Integer>] (required)
    #        An array of product IDs
    #
    # @return [AddProductsResponse] successful response
    # @raise [AddProductsError] if the request fails
    api_method def self.add_products(products:)
      use_connection do |connection|
        connection.post(
          "/storefront/#{id}/product",
          { products: }.compact,
        )
      end
    end

    # Successful response from calling #publish.
    class PublishResponse < PaystackGateway::Response; end

    # Error response from #publish.
    class PublishError < ApiError; end

    # https://paystack.com/docs/api/storefront/#publish
    # Publish Storefront: POST /storefront/{id}/publish
    #
    #
    # @return [PublishResponse] successful response
    # @raise [PublishError] if the request fails
    api_method def self.publish
      use_connection do |connection|
        connection.post(
          "/storefront/#{id}/publish",
        )
      end
    end

    # Successful response from calling #duplicate.
    class DuplicateResponse < PaystackGateway::Response; end

    # Error response from #duplicate.
    class DuplicateError < ApiError; end

    # https://paystack.com/docs/api/storefront/#duplicate
    # Duplicate Storefront: POST /storefront/{id}/duplicate
    #
    #
    # @return [DuplicateResponse] successful response
    # @raise [DuplicateError] if the request fails
    api_method def self.duplicate
      use_connection do |connection|
        connection.post(
          "/storefront/#{id}/duplicate",
        )
      end
    end
  end
end
