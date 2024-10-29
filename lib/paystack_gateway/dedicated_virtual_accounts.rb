# frozen_string_literal: true

module PaystackGateway
  # The Dedicated Virtual Account API enables Nigerian merchants to manage unique
  # payment accounts of their customers.
  # https://paystack.com/docs/api/dedicated-virtual-account/
  module DedicatedVirtualAccounts
    include PaystackGateway::RequestModule

    # Response from POST /dedicated_account endpoint.
    class CreateDedicatedVirtualAccountResponse < PaystackGateway::Response; end

    api_method def self.create_dedicated_virtual_account(customer_id_or_code:, subaccount_code:, preferred_bank:)
      use_connection do |connection|
        connection.post(
          '/dedicated_account',
          {
            customer: customer_id_or_code,
            preferred_bank:,
            subaccount: subaccount_code,
            phone: '+2348011111111', # phone number is required by paystack for some reason, use fake phone number
          },
        )
      end
    end

    # Response from POST /dedicated_account/assign endpoint.
    class AssignDedicatedVirtualAccountResponse < PaystackGateway::Response; end

    api_method def self.assign_dedicated_virtual_account(
      email:, first_name:, last_name:, subaccount_code:, preferred_bank:
    )
      use_connection do |connection|
        connection.post(
          '/dedicated_account/assign',
          {
            email:,
            first_name:,
            last_name:,
            preferred_bank:,
            country: :NG,
            subaccount: subaccount_code,
          },
        )
      end
    end

    # Response from POST /dedicated_account/split endpoint
    class SplitDedicatedAccountTransactionResponse < PaystackGateway::Response; end

    api_method def self.split_dedicated_account_transaction(customer_id_or_code:, subaccount_code:)
      use_connection do |connection|
        connection.post('/dedicated_account/split', { customer: customer_id_or_code, subaccount: subaccount_code })
      end
    end

    # Response from GET /dedicated_account endpoint
    class RequeryDedicatedAccountResponse < PaystackGateway::Response; end

    api_method def self.requery_dedicated_account(account_number:, bank:)
      use_connection do |connection|
        connection.get('/dedicated_account', { account_number:, provider_slug: bank })
      end
    end
  end
end
