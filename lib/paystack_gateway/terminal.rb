# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/terminal
  #
  # Terminal
  # A collection of endpoints for building delightful in-person payment experiences
  module Terminal
    include PaystackGateway::RequestModule

    # Successful response from calling #send_event.
    class SendEventResponse < PaystackGateway::Response; end

    # Error response from #send_event.
    class SendEventError < ApiError; end

    # https://paystack.com/docs/api/terminal/#send_event
    # Send Event: POST /terminal/{id}/event
    # Send an event from your application to the Paystack Terminal
    #
    # @param id [String] (required)
    # @param type ["invoice", "transaction"] (required)
    #        The type of event to push
    # @param action ["process", "view", "print"] (required)
    #        The action the Terminal needs to perform. For the invoice type, the action can either
    #        be process or view. For the transaction type, the action can either be process or
    #        print.
    # @param data [Hash] (required)
    #        The parameters needed to perform the specified action
    #   @option data [Integer] :id
    #           The invoice or transaction ID you want to push to the Terminal
    #   @option data [String] :reference
    #           The offline_reference from the Payment Request response
    #
    # @return [SendEventResponse] successful response
    # @raise [SendEventError] if the request fails
    api_method def self.send_event(id:, type:, action:, data:)
      use_connection do |connection|
        connection.post(
          "/terminal/#{id}/event",
          { type:, action:, data: }.compact,
        )
      end
    end

    # Successful response from calling #fetch_event_status.
    class FetchEventStatusResponse < PaystackGateway::Response; end

    # Error response from #fetch_event_status.
    class FetchEventStatusError < ApiError; end

    # https://paystack.com/docs/api/terminal/#fetch_event_status
    # Fetch Event Status: GET /terminal/{terminal_id}/event/{event_id}
    # Check the status of an event sent to the Terminal
    #
    # @param terminal_id [String] (required)
    # @param event_id [String] (required)
    #
    # @return [FetchEventStatusResponse] successful response
    # @raise [FetchEventStatusError] if the request fails
    api_method def self.fetch_event_status(terminal_id:, event_id:)
      use_connection do |connection|
        connection.get(
          "/terminal/#{terminal_id}/event/#{event_id}",
        )
      end
    end

    # Successful response from calling #fetch_terminal_status.
    class FetchTerminalStatusResponse < PaystackGateway::Response
      delegate :online, :available, to: :data
    end

    # Error response from #fetch_terminal_status.
    class FetchTerminalStatusError < ApiError; end

    # https://paystack.com/docs/api/terminal/#fetch_terminal_status
    # Fetch Terminal Status: GET /terminal/{terminal_id}/presence
    # Check the availiability of a Terminal before sending an event to it
    #
    # @param terminal_id [String] (required)
    #
    # @return [FetchTerminalStatusResponse] successful response
    # @raise [FetchTerminalStatusError] if the request fails
    api_method def self.fetch_terminal_status(terminal_id:)
      use_connection do |connection|
        connection.get(
          "/terminal/#{terminal_id}/presence",
        )
      end
    end

    # Successful response from calling #list.
    class ListResponse < PaystackGateway::Response; end

    # Error response from #list.
    class ListError < ApiError; end

    # https://paystack.com/docs/api/terminal/#list
    # List Terminals: GET /terminal
    # List the Terminals available on your integration
    #
    # @param next [String]
    # @param previous [String]
    # @param per_page [String]
    #
    # @return [ListResponse] successful response
    # @raise [ListError] if the request fails
    api_method def self.list(next: nil, previous: nil, per_page: nil)
      use_connection do |connection|
        connection.get(
          '/terminal',
          { next:, previous:, per_page: }.compact,
        )
      end
    end

    # Successful response from calling #fetch.
    class FetchResponse < PaystackGateway::Response
      delegate :id,
               :serial_number,
               :device_make,
               :terminal_id,
               :integration,
               :domain,
               :name,
               :address,
               :split_code, to: :data
    end

    # Error response from #fetch.
    class FetchError < ApiError; end

    # https://paystack.com/docs/api/terminal/#fetch
    # Fetch Terminal: GET /terminal/{terminal_id}
    # Get the details of a Terminal
    #
    #
    # @return [FetchResponse] successful response
    # @raise [FetchError] if the request fails
    api_method def self.fetch
      use_connection do |connection|
        connection.get(
          "/terminal/#{terminal_id}",
        )
      end
    end

    # Successful response from calling #update.
    class UpdateResponse < PaystackGateway::Response; end

    # Error response from #update.
    class UpdateError < ApiError; end

    # https://paystack.com/docs/api/terminal/#update
    # Update Terminal: PUT /terminal/{terminal_id}
    #
    # @param name [String] (required)
    #        The new name for the Terminal
    # @param address [String] (required)
    #        The new address for the Terminal
    #
    # @return [UpdateResponse] successful response
    # @raise [UpdateError] if the request fails
    api_method def self.update(name:, address:)
      use_connection do |connection|
        connection.put(
          "/terminal/#{terminal_id}",
          { name:, address: }.compact,
        )
      end
    end

    # Successful response from calling #commission.
    class CommissionResponse < PaystackGateway::Response; end

    # Error response from #commission.
    class CommissionError < ApiError; end

    # https://paystack.com/docs/api/terminal/#commission
    # Commission Terminal: POST /terminal/commission_device
    # Activate your debug device by linking it to your integration
    #
    # @param serial_number [String] (required)
    #        Device Serial Number
    #
    # @return [CommissionResponse] successful response
    # @raise [CommissionError] if the request fails
    api_method def self.commission(serial_number:)
      use_connection do |connection|
        connection.post(
          '/terminal/commission_device',
          { serial_number: }.compact,
        )
      end
    end

    # Successful response from calling #decommission.
    class DecommissionResponse < PaystackGateway::Response; end

    # Error response from #decommission.
    class DecommissionError < ApiError; end

    # https://paystack.com/docs/api/terminal/#decommission
    # Decommission Terminal: POST /terminal/decommission_device
    # Unlink your debug device from your integration
    #
    # @param serial_number [String] (required)
    #        Device Serial Number
    #
    # @return [DecommissionResponse] successful response
    # @raise [DecommissionError] if the request fails
    api_method def self.decommission(serial_number:)
      use_connection do |connection|
        connection.post(
          '/terminal/decommission_device',
          { serial_number: }.compact,
        )
      end
    end
  end
end
