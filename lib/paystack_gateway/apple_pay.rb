# frozen_string_literal: true

module PaystackGateway
  # https://paystack.com/docs/api/applepay
  #
  # Apple Pay
  # A collection of endpoints for managing application's top-level domain or subdomain accepting payment via Apple Pay
  module ApplePay
    include PaystackGateway::RequestModule

    # Successful response from calling #list_domain.
    class ListDomainResponse < PaystackGateway::Response; end

    # Error response from #list_domain.
    class ListDomainError < ApiError; end

    # https://paystack.com/docs/api/apple-pay/#list_domain
    # List Domains: GET /apple-pay/domain
    # Lists all registered domains on your integration
    #
    # @param use_cursor [Boolean]
    # @param next [String]
    # @param previous [String]
    #
    # @return [ListDomainResponse] successful response
    # @raise [ListDomainError] if the request fails
    api_method def self.list_domain(use_cursor: nil, next: nil, previous: nil)
      use_connection do |connection|
        connection.get(
          '/apple-pay/domain',
          { use_cursor:, next:, previous: }.compact,
        )
      end
    end

    # Successful response from calling #register_domain.
    class RegisterDomainResponse < PaystackGateway::Response; end

    # Error response from #register_domain.
    class RegisterDomainError < ApiError; end

    # https://paystack.com/docs/api/apple-pay/#register_domain
    # Register Domain: POST /apple-pay/domain
    # Register a top-level domain or subdomain for your Apple Pay integration.
    #
    # @param domainName [String] (required)
    #        The domain or subdomain for your application
    #
    # @return [RegisterDomainResponse] successful response
    # @raise [RegisterDomainError] if the request fails
    api_method def self.register_domain(domain_name:)
      use_connection do |connection|
        connection.post(
          '/apple-pay/domain',
          { domainName: domain_name }.compact,
        )
      end
    end

    # Successful response from calling #unregister_domain.
    class UnregisterDomainResponse < PaystackGateway::Response; end

    # Error response from #unregister_domain.
    class UnregisterDomainError < ApiError; end

    # https://paystack.com/docs/api/apple-pay/#unregister_domain
    # Unregister Domain: DELETE /apple-pay/domain
    # Unregister a top-level domain or subdomain previously used for your Apple Pay integration.
    #
    # @param domainName [String] (required)
    #        The domain or subdomain for your application
    #
    # @return [UnregisterDomainResponse] successful response
    # @raise [UnregisterDomainError] if the request fails
    api_method def self.unregister_domain(domain_name:)
      use_connection do |connection|
        connection.delete(
          '/apple-pay/domain',
          { domainName: domain_name }.compact,
        )
      end
    end
  end
end
