# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/subscription
  #
  # Subscriptions
  # A collection of endpoints for creating and managing recurring payments
  module Subscription
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/subscription/#list
    # List Subscriptions: GET /subscription
    #
    # @param perPage [Integer]
    #        Number of records to fetch per page
    # @param page [Integer]
    #        The section to retrieve
    # @param plan [String]
    #        Plan ID
    # @param customer [String]
    #        Customer ID
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
      plan: nil,
      customer: nil,
      from: nil,
      to: nil
    )
      use_connection do |connection|
        connection.get(
          '/subscription',
          {
            perPage: per_page,
            page:,
            plan:,
            customer:,
            from:,
            to:,
          }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :customer,
               :plan,
               :integration,
               :domain,
               :start,
               :quantity,
               :amount,
               :authorization,
               :invoice_limit,
               :split_code,
               :subscription_code,
               :email_token,
               :id,
               :cancelledAt,
               :createdAt,
               :updatedAt,
               :cron_expression,
               :next_payment_date, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/subscription/#create
    # Create Subscription: POST /subscription
    #
    # @param customer [String] (required)
    #        Customer's email address or customer code
    # @param plan [String] (required)
    #        Plan code
    # @param authorization [String]
    #        If customer has multiple authorizations, you can set the desired authorization you
    #        wish to use for this subscription here. If this is not supplied, the customer's
    #        most recent authorization would be used
    # @param start_date [Time]
    #        Set the date for the first debit. (ISO 8601 format) e.g. 2017-05-16T00:30:13+01:00
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(customer:, plan:, authorization: nil, start_date: nil)
      use_connection do |connection|
        connection.post(
          '/subscription',
          { customer:, plan:, authorization:, start_date: }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :id,
               :domain,
               :subscription_code,
               :email_token,
               :amount,
               :cron_expression,
               :next_payment_date,
               :open_invoice,
               :createdAt,
               :cancelledAt,
               :integration,
               :plan,
               :authorization,
               :customer,
               :invoices,
               :invoices_history,
               :invoice_limit,
               :split_code,
               :most_recent_invoice,
               :payments_count, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/subscription/#fetch
    # Fetch Subscription: GET /subscription/{code}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/subscription/#{code}",
        )
      end
    end

    # Successful response from calling #disable.
    class DisableResponse < PaystackGateway::Response; end

    # Error response from #disable.
    class DisableError < ApiError; end

    # https://paystack.com/docs/api/subscription/#disable
    # Disable Subscription: POST /subscription/disable
    #
    # @param code [String] (required)
    #        Subscription code
    # @param token [String] (required)
    #        Email token
    #
    # @return [DisableResponse] successful response
    # @raise [DisableError] if the request fails
    api_method def self.disable(code:, token:)
      use_connection do |connection|
        connection.post(
          '/subscription/disable',
          { code:, token: }.compact,
        )
      end
    end

    # Successful response from calling #enable.
    class EnableResponse < PaystackGateway::Response; end

    # Error response from #enable.
    class EnableError < ApiError; end

    # https://paystack.com/docs/api/subscription/#enable
    # Enable Subscription: POST /subscription/enable
    #
    # @param code [String] (required)
    #        Subscription code
    # @param token [String] (required)
    #        Email token
    #
    # @return [EnableResponse] successful response
    # @raise [EnableError] if the request fails
    api_method def self.enable(code:, token:)
      use_connection do |connection|
        connection.post(
          '/subscription/enable',
          { code:, token: }.compact,
        )
      end
    end

    # Successful response from calling #manage_link.
    class ManageLinkResponse < PaystackGateway::Response; end

    # Error response from #manage_link.
    class ManageLinkError < ApiError; end

    # https://paystack.com/docs/api/subscription/#manage_link
    # Generate Update Subscription Link: GET /subscription/{code}/manage/link
    #
    # @param code [String] (required)
    #
    # @return [ManageLinkResponse] successful response
    # @raise [ManageLinkError] if the request fails
    api_method def self.manage_link(code:)
      use_connection do |connection|
        connection.get(
          "/subscription/#{code}/manage/link",
        )
      end
    end

    # Successful response from calling #manage_email.
    class ManageEmailResponse < PaystackGateway::Response; end

    # Error response from #manage_email.
    class ManageEmailError < ApiError; end

    # https://paystack.com/docs/api/subscription/#manage_email
    # Send Update Subscription Link: POST /subscription/{code}/manage/email
    #
    # @param code [String] (required)
    #
    # @return [ManageEmailResponse] successful response
    # @raise [ManageEmailError] if the request fails
    api_method def self.manage_email(code:)
      use_connection do |connection|
        connection.post(
          "/subscription/#{code}/manage/email",
        )
      end
    end
  end
end
