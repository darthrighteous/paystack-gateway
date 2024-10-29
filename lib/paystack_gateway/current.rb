# frozen_string_literal: true

require 'active_support/isolated_execution_state'
require 'active_support/code_generator'
require 'active_support/current_attributes'

module PaystackGateway
  # Global singleton providing thread isolated attributes, used and reset around
  # each api method call.
  class Current < ActiveSupport::CurrentAttributes
    attribute :api_module, :api_method_name

    def response_class
      class_name = "#{api_method_name}_response".camelize.to_sym
      api_module.const_defined?(class_name) ? api_module.const_get(class_name) : PaystackGateway::Response
    end

    def error_class
      class_name = "#{api_method_name}_error".camelize
      api_module.const_defined?(class_name) ? api_module.const_get(class_name) : PaystackGateway::ApiError
    end

    def qualified_api_method_name = "#{api_module.name}##{api_method_name}"
  end
end
