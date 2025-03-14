# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/paymentrequest
  #
  # Payment Requests
  # A collection of endpoints for managing invoices for the payment of goods and services
  module PaymentRequest
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/payment-request/#list
    # List Payment Request: GET /paymentrequest
    #
    # @param perPage [Integer]
    #        Number of records to fetch per page
    # @param page [Integer]
    #        The section to retrieve
    # @param customer [String]
    #        Customer ID
    # @param status [String]
    #        Invoice status to filter
    # @param currency [String]
    #        If your integration supports more than one currency, choose the one to filter
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
      customer: nil,
      status: nil,
      currency: nil,
      from: nil,
      to: nil
    )
      use_connection do |connection|
        connection.get(
          '/paymentrequest',
          {
            perPage: per_page,
            page:,
            customer:,
            status:,
            currency:,
            from:,
            to:,
          }.compact,
        )
      end
    end

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
      delegate :id,
               :integration,
               :domain,
               :amount,
               :currency,
               :due_date,
               :has_invoice,
               :invoice_number,
               :description,
               :line_items,
               :tax,
               :request_code,
               :paid,
               :metadata,
               :notifications,
               :offline_reference,
               :customer,
               :created_at,
               :discount,
               :split_code, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/payment-request/#create
    # Create Payment Request: POST /paymentrequest
    #
    # @param customer [String] (required)
    #        Customer id or code
    # @param amount [Integer]
    #        Payment request amount. Only useful if line items and tax values are ignored. The
    #        endpoint will throw a friendly warning if neither is available.
    # @param currency [String]
    #        Specify the currency of the invoice. Allowed values are NGN, GHS, ZAR and USD. Defaults
    #        to NGN
    # @param due_date [Time]
    #        ISO 8601 representation of request due date
    # @param description [String]
    #        A short description of the payment request
    # @param line_items [Array<Hash>]
    #        Array of line items
    # @param tax [Array<Hash>]
    #        Array of taxes
    # @param send_notification [Boolean]
    #        Indicates whether Paystack sends an email notification to customer. Defaults to
    #        true
    # @param draft [Boolean]
    #        Indicate if request should be saved as draft. Defaults to false and overrides send_notification
    # @param has_invoice [Boolean]
    #        Set to true to create a draft invoice (adds an auto incrementing invoice number
    #        if none is provided) even if there are no line_items or tax passed
    # @param invoice_number [Integer]
    #        Numeric value of invoice. Invoice will start from 1 and auto increment from there.
    #        This field is to help override whatever value Paystack decides. Auto increment for
    #        subsequent invoices continue from this point.
    # @param split_code [String]
    #        The split code of the transaction split.
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(
      customer:,
      amount: nil,
      currency: nil,
      due_date: nil,
      description: nil,
      line_items: nil,
      tax: nil,
      send_notification: nil,
      draft: nil,
      has_invoice: nil,
      invoice_number: nil,
      split_code: nil
    )
      use_connection do |connection|
        connection.post(
          '/paymentrequest',
          {
            customer:,
            amount:,
            currency:,
            due_date:,
            description:,
            line_items:,
            tax:,
            send_notification:,
            draft:,
            has_invoice:,
            invoice_number:,
            split_code:,
          }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response; end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/payment-request/#fetch
    # Fetch Payment Request: GET /paymentrequest/{id}
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/paymentrequest/#{id}",
        )
      end
    end

    # Successful response from calling #update.
    class UpdateResponse < PaystackGateway::Response
      delegate :id,
               :integration,
               :domain,
               :amount,
               :currency,
               :due_date,
               :has_invoice,
               :invoice_number,
               :description,
               :pdf_url,
               :line_items,
               :tax,
               :request_code,
               :paid,
               :paid_at,
               :metadata,
               :notifications,
               :offline_reference,
               :customer,
               :created_at,
               :discount,
               :split_code, to: :data
    end

    # Error response from #update.
    class UpdateError < ApiError; end

    # https://paystack.com/docs/api/payment-request/#update
    # Update Payment Request: PUT /paymentrequest/{id}
    #
    # @param customer [String] (required)
    #        Customer id or code
    # @param amount [Integer] (required)
    #        Payment request amount. Only useful if line items and tax values are ignored. The
    #        endpoint will throw a friendly warning if neither is available.
    # @param currency [String] (required)
    #        Specify the currency of the invoice. Allowed values are NGN, GHS, ZAR and USD. Defaults
    #        to NGN
    # @param due_date [Time] (required)
    #        ISO 8601 representation of request due date
    # @param description [String] (required)
    #        A short description of the payment request
    # @param line_items [Array<Hash>] (required)
    #        Array of line items
    # @param tax [Array<Hash>] (required)
    #        Array of taxes
    # @param send_notification [Boolean] (required)
    #        Indicates whether Paystack sends an email notification to customer. Defaults to
    #        true
    # @param draft [Boolean] (required)
    #        Indicate if request should be saved as draft. Defaults to false and overrides send_notification
    # @param has_invoice [Boolean] (required)
    #        Set to true to create a draft invoice (adds an auto incrementing invoice number
    #        if none is provided) even if there are no line_items or tax passed
    # @param invoice_number [Integer] (required)
    #        Numeric value of invoice. Invoice will start from 1 and auto increment from there.
    #        This field is to help override whatever value Paystack decides. Auto increment for
    #        subsequent invoices continue from this point.
    # @param split_code [String] (required)
    #        The split code of the transaction split.
    #
    # @return [UpdateResponse] successful response
    # @raise [UpdateError] if the request fails
    api_method def self.update(
      customer:,
      amount:,
      currency:,
      due_date:,
      description:,
      line_items:,
      tax:,
      send_notification:,
      draft:,
      has_invoice:,
      invoice_number:,
      split_code:
    )
      use_connection do |connection|
        connection.put(
          "/paymentrequest/#{id}",
          {
            customer:,
            amount:,
            currency:,
            due_date:,
            description:,
            line_items:,
            tax:,
            send_notification:,
            draft:,
            has_invoice:,
            invoice_number:,
            split_code:,
          }.compact,
        )
      end
    end

    # Successful response from calling #verify.
    class VerifyResponse < PaystackGateway::Response
      delegate :id,
               :integration,
               :domain,
               :amount,
               :currency,
               :due_date,
               :has_invoice,
               :invoice_number,
               :description,
               :pdf_url,
               :line_items,
               :tax,
               :request_code,
               :paid,
               :paid_at,
               :metadata,
               :notifications,
               :offline_reference,
               :customer,
               :created_at,
               :discount,
               :split_code,
               :pending_amount, to: :data
    end

    # Error response from #verify.
    class VerifyError < ApiError; end

    # https://paystack.com/docs/api/payment-request/#verify
    # Verify Payment Request: GET /paymentrequest/verify/{id}
    #
    #
    # @return [VerifyResponse] successful response
    # @raise [VerifyError] if the request fails
    api_method def self.verify
      use_connection do |connection|
        connection.get(
          "/paymentrequest/verify/#{id}",
        )
      end
    end

    # Successful response from calling #notify.
    class NotifyResponse < PaystackGateway::Response; end

    # Error response from #notify.
    class NotifyError < ApiError; end

    # https://paystack.com/docs/api/payment-request/#notify
    # Send Notification: POST /paymentrequest/notify/{id}
    #
    #
    # @return [NotifyResponse] successful response
    # @raise [NotifyError] if the request fails
    api_method def self.notify
      use_connection do |connection|
        connection.post(
          "/paymentrequest/notify/#{id}",
        )
      end
    end

    # Successful response from calling #totals.
    class TotalsResponse < PaystackGateway::Response
      delegate :pending, :successful, :total, to: :data
    end

    # Error response from #totals.
    class TotalsError < ApiError; end

    # https://paystack.com/docs/api/payment-request/#totals
    # Payment Request Total: GET /paymentrequest/totals
    #
    #
    # @return [TotalsResponse] successful response
    # @raise [TotalsError] if the request fails
    api_method def self.totals
      use_connection do |connection|
        connection.get(
          '/paymentrequest/totals',
        )
      end
    end

    # Successful response from calling #finalize.
    class FinalizeResponse < PaystackGateway::Response
      delegate :id,
               :integration,
               :domain,
               :amount,
               :currency,
               :due_date,
               :has_invoice,
               :invoice_number,
               :description,
               :pdf_url,
               :line_items,
               :tax,
               :request_code,
               :paid,
               :paid_at,
               :metadata,
               :notifications,
               :offline_reference,
               :customer,
               :created_at,
               :discount,
               :split_code,
               :pending_amount, to: :data
    end

    # Error response from #finalize.
    class FinalizeError < ApiError; end

    # https://paystack.com/docs/api/payment-request/#finalize
    # Finalize Payment Request: POST /paymentrequest/finalize/{id}
    #
    #
    # @return [FinalizeResponse] successful response
    # @raise [FinalizeError] if the request fails
    api_method def self.finalize
      use_connection do |connection|
        connection.post(
          "/paymentrequest/finalize/#{id}",
        )
      end
    end

    # Successful response from calling #archive.
    class ArchiveResponse < PaystackGateway::Response; end

    # Error response from #archive.
    class ArchiveError < ApiError; end

    # https://paystack.com/docs/api/payment-request/#archive
    # Archive Payment Request: POST /paymentrequest/archive/{id}
    #
    #
    # @return [ArchiveResponse] successful response
    # @raise [ArchiveError] if the request fails
    api_method def self.archive
      use_connection do |connection|
        connection.post(
          "/paymentrequest/archive/#{id}",
        )
      end
    end
  end
end
