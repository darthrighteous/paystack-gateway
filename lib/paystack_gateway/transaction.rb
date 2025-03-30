# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/transaction
  #
  # Transactions
  # A collection of endpoints for managing payments
  module Transaction
    include PaystackGateway::RequestModule

    # Successful response from calling #initialize_transaction.
    class InitializeTransactionResponse < PaystackGateway::Response
      delegate :authorization_url, :access_code, :reference, to: :data
    end

    # Error response from #initialize_transaction.
    class InitializeTransactionError < ApiError; end

    # https://paystack.com/docs/api/transaction/#initialize_transaction
    # Initialize Transaction: POST /transaction/initialize
    # Create a new transaction
    #
    # @param email [String] (required)
    #        Customer's email address
    # @param amount [Integer] (required)
    #        Amount should be in smallest denomination of the currency. For example, kobo, if
    #        currency is NGN, pesewas, if currency is GHS, and cents, if currency is ZAR
    # @param currency ["GHS", "KES", "NGN", "ZAR", "USD"]
    #        List of all support currencies
    # @param reference [String]
    #        Unique transaction reference. Only -, ., = and alphanumeric characters allowed.
    # @param channels [Array<"card", "bank", "ussd", "qr", "eft", "mobile_money", "bank_transfer">]
    #        An array of payment channels to control what channels you want to make available
    #        to the user to make a payment with
    # @param callback_url [String]
    #        Fully qualified url, e.g. https://example.com/ to redirect your customers to after
    #        a successful payment. Use this to override the callback url provided on the dashboard
    #        for this transaction
    # @param plan [String]
    #        If transaction is to create a subscription to a predefined plan, provide plan code
    #        here. This would invalidate the value provided in amount
    # @param invoice_limit [Integer]
    #        Number of times to charge customer during subscription to plan
    # @param split_code [String]
    #        The split code of the transaction split
    # @param split [Hash]
    #        Split configuration for transactions
    #   @option split [String] :name
    #           Name of the transaction split
    #   @option split ["percentage", "flat"] :type
    #           The type of transaction split you want to create.
    #   @option split [Array<Hash>] :subaccounts
    #           A list of object containing subaccount code and number of shares
    #   @option split ["NGN", "GHS", "ZAR", "USD"] :currency
    #           The transaction currency
    #   @option split ["subaccount", "account", "all-proportional", "all"] :bearer_type
    #           This allows you specify how the transaction charge should be processed
    #   @option split [String] :bearer_subaccount
    #           This is the subaccount code of the customer or partner that would bear the transaction
    #           charge if you specified subaccount as the bearer type
    # @param subaccount [String]
    #        The code for the subaccount that owns the payment
    # @param transaction_charge [String]
    #        A flat fee to charge the subaccount for a transaction. This overrides the split
    #        percentage set when the subaccount was created
    # @param bearer ["account", "subaccount"]
    #        The bearer of the transaction charge
    # @param label [String]
    #        Used to replace the email address shown on the Checkout
    # @param metadata [String]
    #        Stringified JSON object of custom data
    #
    # @return [InitializeTransactionResponse] successful response
    # @raise [InitializeTransactionError] if the request fails
    api_method def self.initialize_transaction(
      email:,
      amount:,
      currency: nil,
      reference: nil,
      channels: nil,
      callback_url: nil,
      plan: nil,
      invoice_limit: nil,
      split_code: nil,
      split: nil,
      subaccount: nil,
      transaction_charge: nil,
      bearer: nil,
      label: nil,
      metadata: nil
    )
      use_connection do |connection|
        connection.post(
          '/transaction/initialize',
          {
            email:,
            amount:,
            currency:,
            reference:,
            channels:,
            callback_url:,
            plan:,
            invoice_limit:,
            split_code:,
            split:,
            subaccount:,
            transaction_charge:,
            bearer:,
            label:,
            metadata:,
          }.compact,
        )
      end
    end

    # Successful response from calling #verify.
    class VerifyResponse < PaystackGateway::Response
      delegate :id,
               :domain,
               :reference,
               :receipt_number,
               :amount,
               :gateway_response,
               :paid_at,
               :created_at,
               :channel,
               :currency,
               :ip_address,
               :metadata,
               :log,
               :fees,
               :fees_split,
               :authorization,
               :customer,
               :plan,
               :split,
               :order_id,
               :paidAt,
               :createdAt,
               :requested_amount,
               :pos_transaction_data,
               :source,
               :fees_breakdown,
               :connect,
               :transaction_date,
               :plan_object,
               :subaccount, to: :data
    end

    # Error response from #verify.
    class VerifyError < ApiError; end

    # https://paystack.com/docs/api/transaction/#verify
    # Verify Transaction: GET /transaction/verify/{reference}
    # Verify a previously initiated transaction using it's reference
    #
    # @param reference [String] (required)
    #        The transaction reference to verify
    #
    # @return [VerifyResponse] successful response
    # @raise [VerifyError] if the request fails
    api_method def self.verify(reference:)
      use_connection do |connection|
        connection.get(
          "/transaction/verify/#{reference}",
        )
      end
    end

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/transaction/#list
    # List Transactions: GET /transaction
    # List transactions that has occurred on your integration
    #
    # @param use_cursor [Boolean]
    #        A flag to indicate if cursor based pagination should be used
    # @param next [String]
    #        An alphanumeric value returned for every cursor based retrieval, used to retrieve
    #        the next set of data
    # @param previous [String]
    #        An alphanumeric value returned for every cursor based retrieval, used to retrieve
    #        the previous set of data
    # @param per_page [Integer]
    #        The number of records to fetch per request
    # @param page [Integer]
    #        Used to indicate the offeset to retrieve data from
    # @param from [Time]
    #        The start date
    # @param to [Time]
    #        The end date
    # @param channel ["card", "pos", "bank", "dedicated_nuban", "ussd", "bank_transfer"]
    #        The payment method the customer used to complete the transaction
    # @param terminal_id [String]
    #        The terminal ID to filter all transactions from a terminal
    # @param customer_code [String]
    #        The customer code to filter all transactions from a customer
    # @param amount [Integer]
    #        Filter transactions by a certain amount
    # @param status ["success", "failed", "abandoned", "reversed"]
    #        Filter transaction by status
    # @param source ["merchantApi", "checkout", "pos", "virtualTerminal"]
    #        The origin of the payment
    # @param subaccount_code [String]
    #        Filter transaction by subaccount code
    # @param split_code [String]
    #        Filter transaction by split code
    # @param settlement [Integer]
    #        The settlement ID to filter for settled transactions
    #
    # @return [ListResponse] successful response
    # @raise [ListError] if the request fails
    api_method def self.list(
      use_cursor: nil,
      next: nil,
      previous: nil,
      per_page: nil,
      page: nil,
      from: nil,
      to: nil,
      channel: nil,
      terminal_id: nil,
      customer_code: nil,
      amount: nil,
      status: nil,
      source: nil,
      subaccount_code: nil,
      split_code: nil,
      settlement: nil
    )
      use_connection do |connection|
        connection.get(
          '/transaction',
          {
            use_cursor:,
            next:,
            previous:,
            per_page:,
            page:,
            from:,
            to:,
            channel:,
            terminal_id:,
            customer_code:,
            amount:,
            status:,
            source:,
            subaccount_code:,
            split_code:,
            settlement:,
          }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :id,
               :domain,
               :reference,
               :receipt_number,
               :amount,
               :gateway_response,
               :helpdesk_link,
               :paid_at,
               :created_at,
               :channel,
               :currency,
               :ip_address,
               :metadata,
               :log,
               :fees,
               :fees_split,
               :authorization,
               :customer,
               :plan,
               :subaccount,
               :split,
               :order_id,
               :paidAt,
               :createdAt,
               :requested_amount,
               :pos_transaction_data,
               :source,
               :fees_breakdown,
               :connect, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/transaction/#fetch
    # Fetch Transaction: GET /transaction/{id}
    # Fetch a transaction to get its details
    #
    # @param id [String] (required)
    #        The ID of the transaction to fetch
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch(id:)
      use_connection do |connection|
        connection.get(
          "/transaction/#{id}",
        )
      end
    end

    # Successful response from calling #timeline.
    class TimelineResponse < PaystackGateway::Response; end

    # Error response from #timeline.
    class TimelineError < ApiError; end

    # https://paystack.com/docs/api/transaction/#timeline
    # Fetch Transaction Timeline: GET /transaction/timeline/{id}
    # Get the details about the lifecycle of a transaction from initiation to completion
    #
    # @param id [Integer] (required)
    #
    # @return [TimelineResponse] successful response
    # @raise [TimelineError] if the request fails
    api_method def self.timeline(id:)
      use_connection do |connection|
        connection.get(
          "/transaction/timeline/#{id}",
        )
      end
    end

    # Successful response from calling #totals.
    class TotalsResponse < PaystackGateway::Response
      delegate :total_transactions,
               :total_volume,
               :total_volume_by_currency,
               :pending_transfers,
               :pending_transfers_by_currency, to: :data
    end

    # Error response from #totals.
    class TotalsError < ApiError; end

    # https://paystack.com/docs/api/transaction/#totals
    # Transaction Totals: GET /transaction/totals
    # Get the total amount of all transactions
    #
    # @param from [Time]
    #        The start date
    # @param to [Time]
    #        The end date
    #
    # @return [TotalsResponse] successful response
    # @raise [TotalsError] if the request fails
    api_method def self.totals(from: nil, to: nil)
      use_connection do |connection|
        connection.get(
          '/transaction/totals',
          { from:, to: }.compact,
        )
      end
    end

    # Successful response from calling #download.
    class DownloadResponse < PaystackGateway::Response
      delegate :path, :expiresAt, to: :data
    end

    # Error response from #download.
    class DownloadError < ApiError; end

    # https://paystack.com/docs/api/transaction/#download
    # Export Transactions: GET /transaction/export
    #
    # @param from [Time]
    #        The start date
    # @param to [Time]
    #        The end date
    # @param status ["success", "failed", "abandoned", "reversed", "all"]
    #        Filter by the status of the transaction
    # @param customer [String]
    #        Filter by customer code
    # @param subaccount_code [String]
    #        Filter by subaccount code
    # @param settlement [Integer]
    #        Filter by the settlement ID
    #
    # @return [DownloadResponse] successful response
    # @raise [DownloadError] if the request fails
    api_method def self.download(
      from: nil,
      to: nil,
      status: nil,
      customer: nil,
      subaccount_code: nil,
      settlement: nil
    )
      use_connection do |connection|
        connection.get(
          '/transaction/export',
          {
            from:,
            to:,
            status:,
            customer:,
            subaccount_code:,
            settlement:,
          }.compact,
        )
      end
    end

    # Successful response from calling #charge_authorization.
    class ChargeAuthorizationResponse < PaystackGateway::Response
      delegate :amount,
               :currency,
               :transaction_date,
               :reference,
               :domain,
               :redirect_url,
               :metadata,
               :gateway_response,
               :channel,
               :fees,
               :authorization,
               :customer, to: :data
    end

    # Error response from #charge_authorization.
    class ChargeAuthorizationError < ApiError; end

    # https://paystack.com/docs/api/transaction/#charge_authorization
    # Charge Authorization: POST /transaction/charge_authorization
    #
    # @param email [String] (required)
    #        Customer's email address
    # @param amount [Integer] (required)
    #        Amount in the lower denomination of your currency
    # @param authorization_code [String] (required)
    #        Valid authorization code to charge
    # @param reference [String]
    #        Unique transaction reference. Only -, ., = and alphanumeric characters allowed.
    # @param currency ["GHS", "KES", "NGN", "ZAR", "USD"]
    #        List of all support currencies
    # @param split_code [String]
    #        The split code of the transaction split
    # @param subaccount [String]
    #        The code for the subaccount that owns the payment
    # @param transaction_charge [String]
    #        A flat fee to charge the subaccount for a transaction. This overrides the split
    #        percentage set when the subaccount was created
    # @param bearer ["account", "subaccount"]
    #        The bearer of the transaction charge
    # @param metadata [String]
    #        Stringified JSON object of custom data
    # @param queue [Boolean]
    #        If you are making a scheduled charge call, it is a good idea to queue them so the
    #        processing system does not get overloaded causing transaction processing errors.
    #
    # @return [ChargeAuthorizationResponse] successful response
    # @raise [ChargeAuthorizationError] if the request fails
    api_method def self.charge_authorization(
      email:,
      amount:,
      authorization_code:,
      reference: nil,
      currency: nil,
      split_code: nil,
      subaccount: nil,
      transaction_charge: nil,
      bearer: nil,
      metadata: nil,
      queue: nil
    )
      use_connection do |connection|
        connection.post(
          '/transaction/charge_authorization',
          {
            email:,
            amount:,
            authorization_code:,
            reference:,
            currency:,
            split_code:,
            subaccount:,
            transaction_charge:,
            bearer:,
            metadata:,
            queue:,
          }.compact,
        )
      end
    end

    # Successful response from calling #partial_debit.
    class PartialDebitResponse < PaystackGateway::Response
      delegate :amount,
               :currency,
               :transaction_date,
               :reference,
               :domain,
               :gateway_response,
               :channel,
               :ip_address,
               :log,
               :fees,
               :authorization,
               :customer,
               :metadata,
               :plan,
               :requested_amount,
               :id, to: :data
    end

    # Error response from #partial_debit.
    class PartialDebitError < ApiError; end

    # https://paystack.com/docs/api/transaction/#partial_debit
    # Partial Debit: POST /transaction/partial_debit
    #
    # @param email [String] (required)
    #        Customer's email address
    # @param amount [Integer] (required)
    #        Specified in the lowest denomination of your currency
    # @param authorization_code [String] (required)
    #        Valid authorization code to charge
    # @param currency ["GHS", "KES", "NGN", "ZAR", "USD"] (required)
    #        List of all support currencies
    # @param at_least [String]
    #        Minimum amount to charge
    # @param reference [String]
    #        Unique transaction reference. Only -, ., = and alphanumeric characters allowed.
    #
    # @return [PartialDebitResponse] successful response
    # @raise [PartialDebitError] if the request fails
    api_method def self.partial_debit(
      email:,
      amount:,
      authorization_code:,
      currency:,
      at_least: nil,
      reference: nil
    )
      use_connection do |connection|
        connection.post(
          '/transaction/partial_debit',
          {
            email:,
            amount:,
            authorization_code:,
            currency:,
            at_least:,
            reference:,
          }.compact,
        )
      end
    end

    # Successful response from calling #event.
    class EventResponse < PaystackGateway::Response; end

    # Error response from #event.
    class EventError < ApiError; end

    # https://paystack.com/docs/api/transaction/#event
    # Get Transaction Event: GET /transaction/{id}/event
    #
    # @param id [Integer] (required)
    #
    # @return [EventResponse] successful response
    # @raise [EventError] if the request fails
    api_method def self.event(id:)
      use_connection do |connection|
        connection.get(
          "/transaction/#{id}/event",
        )
      end
    end

    # Successful response from calling #session.
    class SessionResponse < PaystackGateway::Response; end

    # Error response from #session.
    class SessionError < ApiError; end

    # https://paystack.com/docs/api/transaction/#session
    # Get Transaction Session: GET /transaction/{id}/session
    #
    # @param id [Integer] (required)
    #
    # @return [SessionResponse] successful response
    # @raise [SessionError] if the request fails
    api_method def self.session(id:)
      use_connection do |connection|
        connection.get(
          "/transaction/#{id}/session",
        )
      end
    end
  end
end
