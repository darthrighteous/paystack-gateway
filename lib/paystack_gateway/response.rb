# frozen_string_literal: true

require 'hashie/dash'
require 'hashie/mash'
require 'hashie/extensions/coercion'

module PaystackGateway
  # Wrapper for responses from Paystack.
  class Response < Hashie::Dash
    include Hashie::Extensions::Coercion

    property :status
    property :message
    property :data
    property :meta

    coerce_key :data, ->(v) { coerce_data(v) }

    def self.coerce_data(value)
      case value
      when Array
        value.map { coerce_data(_1) }
      when Hash
        Hashie::Mash.new(value)
      else
        value
      end
    end
  end
end
