# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/bank
  #
  # Banks
  # A collection of endpoints for managing bank details
  module Bank
    include PaystackGateway::RequestModule

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/bank/#list
    # List Banks: GET /bank
    #
    # @param country [String]
    # @param pay_with_bank_transfer [Boolean]
    # @param use_cursor [Boolean]
    # @param perPage [Integer]
    # @param next [String]
    # @param previous [String]
    # @param gateway [String]
    #
    # @return [ListResponse] successful response
    # @raise [ListError] if the request fails
    api_method def self.list(
      country: nil,
      pay_with_bank_transfer: nil,
      use_cursor: nil,
      per_page: nil,
      next: nil,
      previous: nil,
      gateway: nil
    )
      use_connection do |connection|
        connection.get(
          '/bank',
          {
            country:,
            pay_with_bank_transfer:,
            use_cursor:,
            perPage: per_page,
            next:,
            previous:,
            gateway:,
          }.compact,
        )
      end
    end

    # Successful response from calling #resolve_account_number.
    class ResolveAccountNumberResponse < PaystackGateway::Response
      delegate :account_number, :account_name, :bank_id, to: :data
    end

    # Error response from #resolve_account_number.
    class ResolveAccountNumberError < ApiError; end

    # https://paystack.com/docs/api/bank/#resolve_account_number
    # Resolve Account Number: GET /bank/resolve
    #
    # @param account_number [Integer]
    # @param bank_code [Integer]
    #
    # @return [ResolveAccountNumberResponse] successful response
    # @raise [ResolveAccountNumberError] if the request fails
    api_method def self.resolve_account_number(account_number: nil, bank_code: nil)
      use_connection do |connection|
        connection.get(
          '/bank/resolve',
          { account_number:, bank_code: }.compact,
        )
      end
    end

    # Successful response from calling #validate_account_number.
    class ValidateAccountNumberResponse < PaystackGateway::Response
      delegate :verified, :verificationMessage, to: :data
    end

    # Error response from #validate_account_number.
    class ValidateAccountNumberError < ApiError; end

    # https://paystack.com/docs/api/bank/#validate_account_number
    # Validate Bank Account: POST /bank/validate
    #
    # @param account_name [String] (required)
    #        Customer's first and last name registered with their bank
    # @param account_number [String] (required)
    #        Customer's account number
    # @param account_type ["personal", "business"] (required)
    #        The type of the customer's account number
    # @param bank_code [String] (required)
    #        The bank code of the customer’s bank. You can fetch the bank codes by using our
    #        List Banks endpoint
    # @param country_code [String] (required)
    #        The two digit ISO code of the customer’s bank
    # @param document_type ["identityNumber", "passportNumber", "businessRegistrationNumber"] (required)
    #        Customer’s mode of identity
    # @param document_number [String]
    #        Customer’s mode of identity number
    #
    # @return [ValidateAccountNumberResponse] successful response
    # @raise [ValidateAccountNumberError] if the request fails
    api_method def self.validate_account_number(
      account_name:,
      account_number:,
      account_type:,
      bank_code:,
      country_code:,
      document_type:,
      document_number: nil
    )
      use_connection do |connection|
        connection.post(
          '/bank/validate',
          {
            account_name:,
            account_number:,
            account_type:,
            bank_code:,
            country_code:,
            document_type:,
            document_number:,
          }.compact,
        )
      end
    end
  end
end
