# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/plan
  #
  # Plans
  # A collection of endpoints for creating and managing recurring payment configuration
  module Plan
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/plan/#list
    # List Plans: GET /plan
    #
    # @param perPage [Integer]
    #        Number of records to fetch per page
    # @param page [Integer]
    #        The section to retrieve
    # @param interval [String]
    #        Specify interval of the plan
    # @param amount [Integer]
    #        The amount on the plans to retrieve
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
      interval: nil,
      amount: nil,
      from: nil,
      to: nil
    )
      use_connection do |connection|
        connection.get(
          '/plan',
          {
            perPage: per_page,
            page:,
            interval:,
            amount:,
            from:,
            to:,
          }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :currency,
               :name,
               :amount,
               :interval,
               :integration,
               :domain,
               :plan_code,
               :invoice_limit,
               :send_invoices,
               :send_sms,
               :hosted_page,
               :migrate,
               :is_archived,
               :id,
               :createdAt,
               :updatedAt, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/plan/#create
    # Create Plan: POST /plan
    #
    # @param name [String] (required)
    #        Name of plan
    # @param amount [Integer] (required)
    #        Amount should be in kobo if currency is NGN, pesewas, if currency is GHS, and cents,
    #        if currency is ZAR
    # @param interval [String] (required)
    #        Interval in words. Valid intervals are daily, weekly, monthly,biannually, annually
    # @param description [String]
    #        A description for this plan
    # @param send_invoices [Boolean]
    #        Set to false if you don't want invoices to be sent to your customers
    # @param send_sms [Boolean]
    #        Set to false if you don't want text messages to be sent to your customers
    # @param currency [String]
    #        Currency in which amount is set. Allowed values are NGN, GHS, ZAR or USD
    # @param invoice_limit [Integer]
    #        Number of invoices to raise during subscription to this plan. Can be overridden
    #        by specifying an invoice_limit while subscribing.
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(
      name:,
      amount:,
      interval:,
      description: nil,
      send_invoices: nil,
      send_sms: nil,
      currency: nil,
      invoice_limit: nil
    )
      use_connection do |connection|
        connection.post(
          '/plan',
          {
            name:,
            amount:,
            interval:,
            description:,
            send_invoices:,
            send_sms:,
            currency:,
            invoice_limit:,
          }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :subscriptions,
               :pages,
               :domain,
               :name,
               :plan_code,
               :description,
               :amount,
               :interval,
               :invoice_limit,
               :send_invoices,
               :send_sms,
               :hosted_page,
               :hosted_page_url,
               :hosted_page_summary,
               :currency,
               :migrate,
               :is_deleted,
               :is_archived,
               :id,
               :integration,
               :createdAt,
               :updatedAt,
               :pages_count,
               :subscribers_count,
               :subscriptions_count,
               :active_subscriptions_count,
               :total_revenue,
               :subscribers, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/plan/#fetch
    # Fetch Plan: GET /plan/{code}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/plan/#{code}",
        )
      end
    end

    # Successful response from calling #update.
    class UpdateResponse < PaystackGateway::Response; end

    # Error response from #update.
    class UpdateError < ApiError; end

    # https://paystack.com/docs/api/plan/#update
    # Update Plan: PUT /plan/{code}
    #
    # @param name [String] (required)
    #        Name of plan
    # @param amount [Integer] (required)
    #        Amount should be in kobo if currency is NGN, pesewas, if currency is GHS, and cents,
    #        if currency is ZAR
    # @param interval [String] (required)
    #        Interval in words. Valid intervals are daily, weekly, monthly,biannually, annually
    # @param description [Boolean] (required)
    #        A description for this plan
    # @param send_invoices [Boolean] (required)
    #        Set to false if you don't want invoices to be sent to your customers
    # @param send_sms [Boolean] (required)
    #        Set to false if you don't want text messages to be sent to your customers
    # @param currency [String] (required)
    #        Currency in which amount is set. Allowed values are NGN, GHS, ZAR or USD
    # @param invoice_limit [Integer] (required)
    #        Number of invoices to raise during subscription to this plan. Can be overridden
    #        by specifying an invoice_limit while subscribing.
    #
    # @return [UpdateResponse] successful response
    # @raise [UpdateError] if the request fails
    api_method def self.update(
      name:,
      amount:,
      interval:,
      description:,
      send_invoices:,
      send_sms:,
      currency:,
      invoice_limit:
    )
      use_connection do |connection|
        connection.put(
          "/plan/#{code}",
          {
            name:,
            amount:,
            interval:,
            description:,
            send_invoices:,
            send_sms:,
            currency:,
            invoice_limit:,
          }.compact,
        )
      end
    end
  end
end
