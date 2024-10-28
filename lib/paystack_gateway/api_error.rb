# frozen_string_literal: true

require 'faraday/error'

module PaystackGateway
  # This error is raised when an exception occurs in the process of fulfilling
  # an api method.
  #
  # It allows for dynamic checking of the error message by calling a method.
  # * Calling `error.foo_error?` will return true if the error message is
  #   "foo_error" or "foo".
  #
  # * Calling `error.foo_error!` ensures that subsequent calls to
  #   `error.foo_error?` return true regardless of the message.
  #
  #     api_method def initialize_transaction(**transaction_data)
  #       raise ApiError.new(:invalid_amount, cancellable: true) if !transaction_data[:amount]
  #       ...
  #     end
  #
  #     begin
  #       initialize_transaction({amount: nil})
  #     rescue ApiError => e
  #       handle_invalid_amount_error(e) if e.invalid_amount_error? # => true
  #       cancel_transaction if e.cancellable?
  #     end
  class ApiError < StandardError
    CONNECTION_ERROR_CLASSES = [
      Faraday::ServerError,
      Faraday::ConnectionFailed,
      Faraday::SSLError,
    ].freeze

    attr_reader :original_error, :cancellable
    alias cancellable? cancellable

    def initialize(msg = nil, original_error: nil, cancellable: false)
      super(msg)

      @original_error = original_error
      @cancellable = cancellable
    end

    def network_error? = original_error&.class&.in?(CONNECTION_ERROR_CLASSES)

    def method_missing(method_name, *)
      return super unless method_name.to_s.end_with?('_error?', '_error!')

      if method_name.to_s.end_with?('_error!')
        define_singleton_method(method_name.to_s.sub(/!$/, '?')) { true }
      elsif method_name.to_s.end_with?('_error?')
        matching_messages = [
          method_name.to_s.remove(/_error\?$/),
          method_name.to_s.remove(/\?$/),
        ]
        message.to_s.in?(matching_messages)
      end
    end

    def respond_to_missing?(method_name, *)
      method_name.to_s.end_with?('_error?', '_error!') || super
    end

    private

    def http_code = original_error.try(:response_status)
    def response_body = original_error.try(:response_body)&.with_indifferent_access
  end
end
