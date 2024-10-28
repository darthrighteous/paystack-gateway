# frozen_string_literal: true

module Faraday
  class Response
    # Parse response bodies as Hashie::Mash.
    class Mashify < Middleware
      def initialize(app = nil, mash_class: Hashie::Mash, symbolize: true)
        super(app)

        @mash_class = mash_class
        @symbolize = symbolize
      end

      def on_complete(env)
        process_response(env)
      end

      private

      def process_response(env)
        env[:body] = env[:body].try(:deep_symbolize_keys) if @symbolize
        env[:body] = parse(env[:body])
      rescue StandardError, SyntaxError => e
        raise Faraday::ParsingError.new(e, env[:response])
      end

      def parse(body)
        case body
        when Hash
          @mash_class.new(body)
        when Array
          body.map { |item| parse(item) }
        else
          body
        end
      end
    end
  end
end

Faraday::Response.register_middleware(mashify: Faraday::Response::Mashify)
