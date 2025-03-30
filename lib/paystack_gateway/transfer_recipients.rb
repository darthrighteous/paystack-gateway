# frozen_string_literal: true

module PaystackGateway
  # Create and manage beneficiaries that you send money to
  # https://paystack.com/docs/api/#transfer-recipient
  #
  # @deprecated Use PaystackGateway::TransferRecipient instead.
  module TransferRecipients
    include PaystackGateway::RequestModule

    # Response from POST /transferrecipient endpoint.
    class CreateTransferRecipientResponse < PaystackGateway::Response
      delegate :id, :recipient_code, to: :data
    end

    api_method def self.create_transfer_recipient(name:, account_number:, bank_code:)
      use_connection do |connection|
        connection.post(
          '/transferrecipient',
          { type: :nuban, name: name, account_number: account_number, bank_code: bank_code, currency: :NGN },
        )
      end
    end
  end
end
