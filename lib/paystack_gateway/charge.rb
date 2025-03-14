# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/charge
  #
  # Charges
  # A collection of endpoints for configuring and managing the payment channels when initiating a payment
  module Charge
    include PaystackGateway::RequestModule

    # Successful response from calling #create.
    class CreateResponse < PaystackGateway::Response
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

    # Error response from #create.
    class CreateError < ApiError; end

    # https://paystack.com/docs/api/charge/#create
    # Create Charge: POST /charge
    #
    # @param email [String] (required)
    #        Customer's email address
    # @param amount [String] (required)
    #        Amount should be in kobo if currency is NGN, pesewas, if currency is GHS, and cents,
    #        if currency is ZAR
    # @param authorization_code [String]
    #        An authorization code to charge.
    # @param pin [String]
    #        4-digit PIN (send with a non-reusable authorization code)
    # @param reference [String]
    #        Unique transaction reference. Only -, .`, = and alphanumeric characters allowed.
    # @param birthday [Time]
    #        The customer's birthday in the format YYYY-MM-DD e.g 2017-05-16
    # @param device_id [String]
    #        This is the unique identifier of the device a user uses in making payment. Only
    #        -, .`, = and alphanumeric characters are allowed.
    # @param metadata [String]
    #        Stringified JSON object of custom data
    # @param bank [Hash]
    #   @option bank [String] :code
    #           Customer's bank code
    #   @option bank [String] :account_number
    #           Customer's account number
    # @param mobile_money [Hash]
    #   @option mobile_money [String] :phone
    #           Customer's phone number
    #   @option mobile_money [String] :provider
    #           The telco provider of customer's phone number. This can be fetched from the List
    #           Bank endpoint
    # @param ussd [Hash]
    #   @option ussd ["737", "919", "822", "966"] :type
    #           The three-digit USSD code.
    # @param eft [Hash]
    #   @option eft [String] :provider
    #           The EFT provider
    #
    # @return [CreateResponse] successful response
    # @raise [CreateError] if the request fails
    api_method def self.create(
      email:,
      amount:,
      authorization_code: nil,
      pin: nil,
      reference: nil,
      birthday: nil,
      device_id: nil,
      metadata: nil,
      bank: nil,
      mobile_money: nil,
      ussd: nil,
      eft: nil
    )
      use_connection do |connection|
        connection.post(
          '/charge',
          {
            email:,
            amount:,
            authorization_code:,
            pin:,
            reference:,
            birthday:,
            device_id:,
            metadata:,
            bank:,
            mobile_money:,
            ussd:,
            eft:,
          }.compact,
        )
      end
    end

    # Successful response from calling #submit_pin.
    class SubmitPinResponse < PaystackGateway::Response
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

    # Error response from #submit_pin.
    class SubmitPinError < ApiError; end

    # https://paystack.com/docs/api/charge/#submit_pin
    # Submit PIN: POST /charge/submit_pin
    #
    # @param pin [String] (required)
    #        Customer's PIN
    # @param reference [String] (required)
    #        Transaction reference that requires the PIN
    #
    # @return [SubmitPinResponse] successful response
    # @raise [SubmitPinError] if the request fails
    api_method def self.submit_pin(pin:, reference:)
      use_connection do |connection|
        connection.post(
          '/charge/submit_pin',
          { pin:, reference: }.compact,
        )
      end
    end

    # Successful response from calling #submit_otp.
    class SubmitOtpResponse < PaystackGateway::Response
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

    # Error response from #submit_otp.
    class SubmitOtpError < ApiError; end

    # https://paystack.com/docs/api/charge/#submit_otp
    # Submit OTP: POST /charge/submit_otp
    #
    # @param otp [String] (required)
    #        Customer's OTP
    # @param reference [String] (required)
    #        The reference of the ongoing transaction
    #
    # @return [SubmitOtpResponse] successful response
    # @raise [SubmitOtpError] if the request fails
    api_method def self.submit_otp(otp:, reference:)
      use_connection do |connection|
        connection.post(
          '/charge/submit_otp',
          { otp:, reference: }.compact,
        )
      end
    end

    # Successful response from calling #submit_phone.
    class SubmitPhoneResponse < PaystackGateway::Response
      delegate :reference, :display_text, to: :data
    end

    # Error response from #submit_phone.
    class SubmitPhoneError < ApiError; end

    # https://paystack.com/docs/api/charge/#submit_phone
    # Submit Phone: POST /charge/submit_phone
    #
    # @param phone [String] (required)
    #        Customer's mobile number
    # @param reference [String] (required)
    #        The reference of the ongoing transaction
    #
    # @return [SubmitPhoneResponse] successful response
    # @raise [SubmitPhoneError] if the request fails
    api_method def self.submit_phone(phone:, reference:)
      use_connection do |connection|
        connection.post(
          '/charge/submit_phone',
          { phone:, reference: }.compact,
        )
      end
    end

    # Successful response from calling #submit_birthday.
    class SubmitBirthdayResponse < PaystackGateway::Response
      delegate :display_text, to: :data
    end

    # Error response from #submit_birthday.
    class SubmitBirthdayError < ApiError; end

    # https://paystack.com/docs/api/charge/#submit_birthday
    # Submit Birthday: POST /charge/submit_birthday
    #
    # @param birthday [String] (required)
    #        Customer's birthday in the format YYYY-MM-DD e.g 2016-09-21
    # @param reference [String] (required)
    #        The reference of the ongoing transaction
    #
    # @return [SubmitBirthdayResponse] successful response
    # @raise [SubmitBirthdayError] if the request fails
    api_method def self.submit_birthday(birthday:, reference:)
      use_connection do |connection|
        connection.post(
          '/charge/submit_birthday',
          { birthday:, reference: }.compact,
        )
      end
    end

    # Successful response from calling #submit_address.
    class SubmitAddressResponse < PaystackGateway::Response; end

    # Error response from #submit_address.
    class SubmitAddressError < ApiError; end

    # https://paystack.com/docs/api/charge/#submit_address
    # Submit Address: POST /charge/submit_address
    #
    # @param address [String] (required)
    #        Customer's address
    # @param city [String] (required)
    #        Customer's city
    # @param state [String] (required)
    #        Customer's state
    # @param zipcode [String] (required)
    #        Customer's zipcode
    # @param reference [String] (required)
    #        The reference of the ongoing transaction
    #
    # @return [SubmitAddressResponse] successful response
    # @raise [SubmitAddressError] if the request fails
    api_method def self.submit_address(address:, city:, state:, zipcode:, reference:)
      use_connection do |connection|
        connection.post(
          '/charge/submit_address',
          { address:, city:, state:, zipcode:, reference: }.compact,
        )
      end
    end

    # Successful response from calling #check.
    class CheckResponse < PaystackGateway::Response
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

    # Error response from #check.
    class CheckError < ApiError; end

    # https://paystack.com/docs/api/charge/#check
    # Check pending charge: GET /charge/{reference}
    #
    # @param reference [String] (required)
    #
    # @return [CheckResponse] successful response
    # @raise [CheckError] if the request fails
    api_method def self.check(reference:)
      use_connection do |connection|
        connection.get(
          "/charge/#{reference}",
        )
      end
    end
  end
end
