# frozen_string_literal: true

require 'faraday'
require 'faraday/response/caching'
require 'faraday/response/mashify'
require 'active_support/cache'
require 'active_support/notifications'
require 'active_support/concern'
require 'active_support/core_ext/string/inflections' # for #camelize
require 'active_support/core_ext/numeric/time' # for #days

module PaystackGateway
  # This module provides methods for making API requests to the Paystack
  # payment gateway, including handling responses and errors.
  module RequestModule
    extend ActiveSupport::Concern

    BASE_URL = 'https://api.paystack.co'

    # ClassMethods
    module ClassMethods
      def api_methods = (@api_method_names || Set.new).to_a

      private

      def use_connection(response_class = Current.response_class, cache_options: nil)
        connection = Faraday.new(BASE_URL) do |conn|
          conn.request :json
          conn.request :authorization, 'Bearer', PaystackGateway.secret_key

          conn.response :logger, PaystackGateway.logger, { headers: false, **(PaystackGateway.logging_options || {}) }
          conn.response :mashify, mash_class: response_class

          conn.response :raise_error
          conn.response :json
          conn.response :caching, cache_store(**cache_options) if cache_options
        end

        if block_given?
          response = yield connection
          response.body
        else
          connection
        end
      end

      def cache_store(expires_in: 7.days.to_i, cache_key: nil)
        cache_dir = File.join(ENV['TMPDIR'] || '/tmp', 'cache')
        namespace = cache_key ? "#{name}_#{cache_key}" : name

        ActiveSupport::Cache::FileStore.new cache_dir, namespace:, expires_in: expires_in.to_i
      end

      def api_method(method_name)
        @api_method_names ||= Set.new
        @api_method_names << method_name

        decorate_api_methods(method_name)
      end

      def decorate_api_methods(*method_names)
        singleton_class.class_exec do
          prepend(Module.new do
            method_names.flatten.each do |method_name|
              define_method(method_name) do |*args, **kwargs, &block|
                Current.with(api_module: self, api_method_name: method_name) do
                  super(*args, **kwargs, &block)
                rescue Faraday::Error => e
                  handle_error(e)
                end
              end
            end
          end)
        end
      end

      def handle_error(error)
        PaystackGateway.logger.error "#{Current.qualified_api_method_name}: #{error.message}"
        PaystackGateway.logger.error JSON.pretty_generate(filtered_response(error.response) || {}) if error.response

        raise Current.error_class.new(
          "Paystack error: #{error.message}, status: #{error.response_status}, response: #{error.response_body}",
          original_error: error,
        )
      end

      def filtered_response(response)
        return unless response

        {
          request_method: response.dig(:request, :method),
          request_url: response.dig(:request, :url),
          request_headers: PaystackGateway.log_filter.call(response.dig(:request, :headers)),
          request_body: PaystackGateway.log_filter.call(JSON.parse(response.dig(:request, :body) || '{}')),

          response_status: response[:status],
          response_headers: PaystackGateway.log_filter.call(response[:headers]),
          response_body: PaystackGateway.log_filter.call(response[:body]),
        }
      end
    end
  end
end
