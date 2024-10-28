# frozen_string_literal: true

module PaystackGateway
  # Create and manage subaccounts https://paystack.com/docs/api/subaccount/
  module Subaccounts
    include PaystackGateway::RequestModule

    # Response from POST /subaccount
    class CreateSubaccountResponse < PaystackGateway::Response
      delegate :subaccount_code, to: :data
    end

    api_method def self.create_subaccount(business_name:, settlement_bank:, account_number:, percentage_charge:)
      with_response(CreateSubaccountResponse) do |connection|
        connection.post(
          '/subaccount',
          { business_name:, settlement_bank:, account_number:, percentage_charge: }.compact,
        )
      end
    end

    # Response from PUT /subaccount/:id_or_code
    class UpdateSubaccountResponse < CreateSubaccountResponse; end

    api_method def self.update_subaccount(
      subaccount_code,
      business_name: nil, settlement_bank: nil, account_number: nil, percentage_charge: nil
    )
      with_response(UpdateSubaccountResponse) do |connection|
        connection.put(
          "/subaccount/#{subaccount_code}",
          { business_name:, settlement_bank:, account_number:, percentage_charge: }.compact,
        )
      end
    end
  end
end
