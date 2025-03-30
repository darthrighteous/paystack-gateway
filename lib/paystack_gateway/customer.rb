# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/customer
  #
  # Transaction Splits
  # A collection of endpoints for creating and managing customers on an integration
  module Customer
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/customer/#list
    # List Customers: GET /customer
    # List customers on your integration
    #
    # @param use_cursor [Boolean]
    # @param next [String]
    # @param previous [String]
    # @param from [String]
    # @param to [String]
    # @param perPage [String]
    # @param page [String]
    #
    # @return [ListResponse] successful response
    # @raise [ListError] if the request fails
    api_method def self.list(
      use_cursor: nil,
      next: nil,
      previous: nil,
      from: nil,
      to: nil,
      per_page: nil,
      page: nil
    )
      use_connection do |connection|
        connection.get(
          '/customer',
          {
            use_cursor:,
            next:,
            previous:,
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
      delegate :transactions,
               :subscriptions,
               :authorizations,
               :email,
               :first_name,
               :last_name,
               :phone,
               :integration,
               :domain,
               :metadata,
               :customer_code,
               :risk_action,
               :id,
               :createdAt,
               :updatedAt,
               :identified,
               :identifications, to: :data
    end

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/customer/#create
    # Create Customer: POST /customer
    #
    # @param email [String] (required)
    #        Customer's email address
    # @param first_name [String]
    #        Customer's first name
    # @param last_name [String]
    #        Customer's last name
    # @param phone [String]
    #        Customer's phone number
    # @param metadata [String]
    #        Stringified JSON object of custom data
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(email:, first_name: nil, last_name: nil, phone: nil, metadata: nil)
      use_connection do |connection|
        connection.post(
          '/customer',
          { email:, first_name:, last_name:, phone:, metadata: }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :transactions,
               :subscriptions,
               :authorizations,
               :first_name,
               :last_name,
               :email,
               :phone,
               :metadata,
               :domain,
               :customer_code,
               :risk_action,
               :id,
               :integration,
               :createdAt,
               :updatedAt,
               :created_at,
               :updated_at,
               :total_transactions,
               :total_transaction_value,
               :dedicated_account,
               :dedicated_accounts,
               :identified,
               :identifications, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/customer/#fetch
    # Fetch Customer: GET /customer/{code}
    #
    # @param code [String] (required)
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch(code:)
      use_connection do |connection|
        connection.get(
          "/customer/#{code}",
        )
      end
    end

    # Successful response from calling #update.
    class UpdateResponse < PaystackGateway::Response
      delegate :first_name,
               :last_name,
               :email,
               :phone,
               :metadata,
               :domain,
               :customer_code,
               :risk_action,
               :id,
               :integration,
               :createdAt,
               :updatedAt,
               :identified,
               :identifications, to: :data
    end

    # Error response from #update.
    class UpdateError < ApiError; end

    # https://paystack.com/docs/api/customer/#update
    # Update Customer: PUT /customer/{code}
    #
    # @param first_name [String] (required)
    #        Customer's first name
    # @param last_name [String] (required)
    #        Customer's last name
    # @param phone [String] (required)
    #        Customer's phone number
    # @param metadata [String] (required)
    #        Stringified JSON object of custom data
    #
    # @return [UpdateResponse] successful response
    # @raise [UpdateError] if the request fails
    api_method def self.update(first_name:, last_name:, phone:, metadata:)
      use_connection do |connection|
        connection.put(
          "/customer/#{code}",
          { first_name:, last_name:, phone:, metadata: }.compact,
        )
      end
    end

    # Successful response from calling #risk_action.
    class RiskActionResponse < PaystackGateway::Response
      delegate :transactions,
               :subscriptions,
               :authorizations,
               :first_name,
               :last_name,
               :email,
               :phone,
               :metadata,
               :domain,
               :customer_code,
               :risk_action,
               :id,
               :integration,
               :createdAt,
               :updatedAt,
               :identified,
               :identifications, to: :data
    end

    # Error response from #risk_action.
    class RiskActionError < ApiError; end

    # https://paystack.com/docs/api/customer/#risk_action
    # White/blacklist Customer: POST /customer/set_risk_action
    # Set customer's risk action by whitelisting or blacklisting the customer
    #
    # @param customer [String] (required)
    #        Customer's code, or email address
    # @param risk_action [String]
    #        One of the possible risk actions [ default, allow, deny ]. allow to whitelist. deny
    #        to blacklist. Customers start with a default risk action.
    #
    # @return [RiskActionResponse] successful response
    # @raise [RiskActionError] if the request fails
    api_method def self.risk_action(customer:, risk_action: nil)
      use_connection do |connection|
        connection.post(
          '/customer/set_risk_action',
          { customer:, risk_action: }.compact,
        )
      end
    end

    # Successful response from calling #deactivate_authorization.
    class DeactivateAuthorizationResponse < PaystackGateway::Response; end

    # Error response from #deactivate_authorization.
    class DeactivateAuthorizationError < ApiError; end

    # https://paystack.com/docs/api/customer/#deactivate_authorization
    # Deactivate Authorization: POST /customer/deactivate_authorization
    # Deactivate a customer's card
    #
    # @param authorization_code [String] (required)
    #        Authorization code to be deactivated
    #
    # @return [DeactivateAuthorizationResponse] successful response
    # @raise [DeactivateAuthorizationError] if the request fails
    api_method def self.deactivate_authorization(authorization_code:)
      use_connection do |connection|
        connection.post(
          '/customer/deactivate_authorization',
          { authorization_code: }.compact,
        )
      end
    end

    # Successful response from calling #validate.
    class ValidateResponse < PaystackGateway::Response; end

    # Error response from #validate.
    class ValidateError < ApiError; end

    # https://paystack.com/docs/api/customer/#validate
    # Validate Customer: POST /customer/{code}/identification
    # Validate a customer's identity
    #
    # @param first_name [String] (required)
    #        Customer's first name
    # @param last_name [String] (required)
    #        Customer's last name
    # @param type [String] (required)
    #        Predefined types of identification.
    # @param country [String] (required)
    #        Two-letter country code of identification issuer
    # @param bvn [String] (required)
    #        Customer's Bank Verification Number
    # @param bank_code [String] (required)
    #        You can get the list of bank codes by calling the List Banks endpoint (https://api.paystack.co/bank).
    # @param account_number [String] (required)
    #        Customer's bank account number.
    # @param middle_name [String]
    #        Customer's middle name
    # @param value [String]
    #        Customer's identification number. Required if type is bvn
    #
    # @return [ValidateResponse] successful response
    # @raise [ValidateError] if the request fails
    api_method def self.validate(
      first_name:,
      last_name:,
      type:,
      country:,
      bvn:,
      bank_code:,
      account_number:,
      middle_name: nil,
      value: nil
    )
      use_connection do |connection|
        connection.post(
          "/customer/#{code}/identification",
          {
            first_name:,
            last_name:,
            type:,
            country:,
            bvn:,
            bank_code:,
            account_number:,
            middle_name:,
            value:,
          }.compact,
        )
      end
    end
  end
end
