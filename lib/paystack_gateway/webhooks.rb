# frozen_string_literal: true

require 'active_support/security_utils'

module PaystackGateway
  # Webhooks
  module Webhooks
    # https://paystack.com/docs/payments/webhooks/#ip-whitelisting
    WEBHOOK_IPS = %w[52.31.139.75 52.49.173.169 52.214.14.220].freeze
    WEBHOOK_IP_ADDRESSES = WEBHOOK_IPS.map { |addr| IPAddr.new(addr) }

    # Wrapper for webhook responses from Paystack.
    class WebhookResponse < PaystackGateway::Response
      property :event
    end

    def self.parse_webhook(parsed_body)
      WebhookResponse.new(parsed_body.deep_symbolize_keys)
    end

    # https://paystack.com/docs/payments/webhooks/#signature-validation
    def self.valid_webhook?(request_headers, request_body)
      request_signature = request_headers['X-Paystack-Signature']
      return false if request_signature.blank?

      calculated_signature = OpenSSL::HMAC.hexdigest('SHA512', PaystackGateway.secret_key, request_body)
      ActiveSupport::SecurityUtils.secure_compare(request_signature, calculated_signature)
    end

    def self.valid_ip?(request_ip) = WEBHOOK_IP_ADDRESSES.any? { _1.include?(request_ip) }
  end
end
