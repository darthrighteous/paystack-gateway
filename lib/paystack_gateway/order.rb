# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/order
  #
  # Orders
  # A collection of endpoints for creating and managing orders
  module Order
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/order/#list
    # List Orders: GET /order
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
          '/order',
          { perPage:, page:, from:, to: }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :discounts,
               :currency,
               :shipping_address,
               :integration,
               :domain,
               :email,
               :customer,
               :amount,
               :pay_for_me,
               :shipping,
               :shipping_fees,
               :metadata,
               :order_code,
               :refunded,
               :is_viewed,
               :expiration_date,
               :id,
               :createdAt,
               :updatedAt,
               :items,
               :pay_for_me_code,
               :discount_amount, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/order/#create
    # Create Order: POST /order
    #
    # @param email [String] (required)
    #        The email of the customer placing the order
    # @param first_name [String] (required)
    #        The customer's first name
    # @param last_name [String] (required)
    #        The customer's last name
    # @param phone [String] (required)
    #        The customer's mobile number
    # @param currency [String] (required)
    #        Currency in which amount is set. Allowed values are NGN, GHS, ZAR or USD
    # @param items [Array<Hash>] (required)
    #        The collection of items that make up the order
    # @param shipping [Hash] (required)
    #        The shipping details of the order
    #   @option shipping [String] :street_line
    #           The address of for the delivery
    #   @option shipping [String] :city
    #           The city of the delivery address
    #   @option shipping [String] :state
    #           The state of the delivery address
    #   @option shipping [String] :country
    #           The country of the delivery address
    #   @option shipping [Integer] :shipping_fee
    #           The cost of delivery
    #   @option shipping [String] :delivery_note
    #           Extra details to be aware of for the delivery
    # @param is_gift [Boolean]
    #        A flag to indicate if the order is for someone else
    # @param pay_for_me [Boolean]
    #        A flag to indicate if the someone else should pay for the order
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(
      email:,
      first_name:,
      last_name:,
      phone:,
      currency:,
      items:,
      shipping:,
      is_gift: nil,
      pay_for_me: nil
    )
      use_connection do |connection|
        connection.post(
          '/order',
          {
            email:,
            first_name:,
            last_name:,
            phone:,
            currency:,
            items:,
            shipping:,
            is_gift:,
            pay_for_me:,
          }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :discounts,
               :order_code,
               :domain,
               :currency,
               :amount,
               :email,
               :refunded,
               :paid_at,
               :shipping_address,
               :metadata,
               :shipping_fees,
               :shipping_method,
               :is_viewed,
               :expiration_date,
               :pay_for_me,
               :id,
               :integration,
               :page,
               :customer,
               :shipping,
               :createdAt,
               :updatedAt,
               :transaction,
               :is_gift,
               :payer,
               :fully_refunded,
               :refunded_amount,
               :items,
               :discount_amount, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/order/#fetch
    # Fetch Order: GET /order/{id}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/order/#{id}",
        )
      end
    end

    # Successful response from calling #fetch_products.
    class FetchProductsResponse < PaystackGateway::Response; end

    # Error response from #fetch_products.
    class FetchProductsError < ApiError; end

    # https://paystack.com/docs/api/order/#fetch_products
    # Fetch Products Order: GET /order/product/{id}
    #
    #
    # @return [FetchProductsResponse] successful response
    # @raise [FetchProductsError] if the request fails
    api_method def self.fetch_products
      use_connection do |connection|
        connection.get(
          "/order/product/#{id}",
        )
      end
    end

    # Successful response from calling #validate_pay_for_me.
    class ValidatePayForMeResponse < PaystackGateway::Response
      delegate :order_code,
               :domain,
               :currency,
               :amount,
               :email,
               :refunded,
               :paid_at,
               :shipping_address,
               :metadata,
               :shipping_fees,
               :shipping_method,
               :is_viewed,
               :expiration_date,
               :pay_for_me,
               :id,
               :integration,
               :transaction,
               :page,
               :customer,
               :shipping,
               :createdAt,
               :updatedAt,
               :payer, to: :data
    end

    # Error response from #validate_pay_for_me.
    class ValidatePayForMeError < ApiError; end

    # https://paystack.com/docs/api/order/#validate_pay_for_me
    # Validate pay for me order: GET /order/{code}/validate
    #
    #
    # @return [ValidatePayForMeResponse] successful response
    # @raise [ValidatePayForMeError] if the request fails
    api_method def self.validate_pay_for_me
      use_connection do |connection|
        connection.get(
          "/order/#{code}/validate",
        )
      end
    end
  end
end
