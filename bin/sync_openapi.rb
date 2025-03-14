#!/usr/bin/env ruby
# frozen_string_literal: true

require 'openapi_parser'
require 'paystack_gateway'
require 'debug'

class OpenApiGenerator
  def generate
    api_methods_by_api_module_name.each do |api_module_name, api_methods|
      puts "Processing #{api_module_name}"

      if existing_api_modules.include?(api_module_name)
        puts "Updating existing module: #{api_module_name}"
      else
        puts "Creating new module: #{api_module_name}"
      end

      create_new_module(api_module_name, api_methods)
    end
  end

  private

  SDK_ROOT = File.expand_path('..', __dir__)
  LIB_DIR = File.join(SDK_ROOT, 'lib', 'paystack_gateway')
  OPENAPI_SPEC = File.join(SDK_ROOT, 'openapi', 'base', 'paystack.yaml')
  INDENT = '  '

  def api_methods_by_api_module_name
    @api_methods_by_api_module_name ||=
      document.paths.path.each_with_object({}) do |(path, path_item), paths_by_api_module|
        %w[get post put patch delete].each do |http_method|
          operation = path_item.operation(http_method)
          next if !operation

          api_module_name = operation.tags.first.remove(' ')
          next if !api_module_name

          paths_by_api_module[api_module_name] ||= []
          paths_by_api_module[api_module_name] << { path:, http_method:, operation: }
        end
      end
  end

  def create_new_module(api_module_name, api_methods)
    file_path = File.join(LIB_DIR, "#{api_module_name.underscore}.rb")
    puts "Creating new module file: #{file_path}"

    content = api_module_content(api_module_name, api_methods)
    File.write(file_path, content)
  end

  def api_module_content(api_module_name, api_methods)
    <<~RUBY
      # frozen_string_literal: true

      module PaystackGateway
        # = #{tags_by_name.dig(api_module_name, 'x-product-name')&.chomp}
        # #{tags_by_name.dig(api_module_name, 'description')&.chomp}
        # https://paystack.com/docs/api/#{api_module_name.parameterize}
        module #{api_module_name}
          include PaystackGateway::RequestModule

      #{api_methods.map { |info| api_method_composition(api_module_name, info) }.join("\n").chomp}
        end
      end
    RUBY
  end

  def api_method_composition(api_module_name, api_method_info)
    api_method_info => { path:, http_method:, operation: }

    api_method_name = api_method_name(api_module_name, operation)
    <<~RUBY.chomp
      #{api_method_response_class_content(api_method_name, operation)}

      #{api_method_error_class_content(api_method_name)}

      #{api_method_content(api_method_name, operation, http_method, path)}
    RUBY
  end

  def api_method_response_class_content(api_method_name, operation)
    responses = operation.responses.response
    success_response = responses[responses.keys.find { _1.match?(/\A2..\z/) }]

    definition = "#{INDENT * 2}# Successful response from calling ##{api_method_name}.\n"
    definition += "#{INDENT * 2}class #{"#{api_method_name}_response".camelize} < PaystackGateway::Response"

    if success_response
      "#{definition}\n#{INDENT * 2}end"
    else
      "#{definition}; end"
    end
  end

  def api_method_error_class_content(api_method_name)
    definition = "#{INDENT * 2}# Error response from ##{api_method_name}.\n"
    definition + "#{INDENT * 2}class #{"#{api_method_name}_error".camelize} < ApiError; end"
  end

  def api_method_content(api_method_name, operation, http_method, path)
    <<-RUBY
    #{api_method_definition_name_and_parameters(api_method_name, operation)}
      use_connection do |connection|
        connection.#{http_method}(
          #{api_method_definition_path(path)},#{api_method_definition_request_params(operation)}
        )
      end
    end
    RUBY
  end

  def api_method_definition_name_and_parameters(api_method_name, operation)
    api_method_parameters(operation) => { required:, optional: }

    method_args = [
      *required.map { |param| "#{param}:" },
      *optional.map { |param| "#{param}: nil" },
    ]

    definition = "api_method def self.#{api_method_name}("

    if method_args.length > 5
      while (line_arg = method_args.shift).present?
        definition += "\n#{INDENT * 3}#{line_arg}"
        definition += ',' if method_args.any?
      end
      definition + "\n#{INDENT * 2})"
    else
      definition + "#{method_args.join(', ')})"
    end
  end

  def api_method_definition_path(path)
    # "/transaction/verify/{reference}" -> "/transaction/verify/#{reference}"
    interpolated_path = path.gsub(/{([^}]+)}/, "\#{\\1}")

    interpolated_path == path ? "'#{interpolated_path}'" : "\"#{interpolated_path}\""
  end

  def api_method_definition_request_params(operation)
    api_method_path_and_query_parameters(operation) => { query_params: }
    api_method_request_body_parameters(operation) => { required:, optional: }
    params = required + optional + query_params

    return if params.none?

    definition = "\n#{INDENT * 5}{"

    if params.length > 5
      while (line_param = params.shift).present?
        definition += "\n#{INDENT * 6}#{line_param}:,"
      end

      definition + "\n#{INDENT * 5}}.compact,"
    else
      "#{definition} #{params.map { |param| "#{param}:" }.join(', ')} }.compact,"
    end
  end

  def api_method_parameters(operation)
    path_and_query_params = api_method_path_and_query_parameters(operation)
    body_params = api_method_request_body_parameters(operation)

    required = path_and_query_params[:path_params] + body_params[:required]
    optional = body_params[:optional] + path_and_query_params[:query_params]

    { required:, optional: }
  end

  def api_method_path_and_query_parameters(operation)
    path_params = []
    query_params = []

    path_params, query_params = operation.parameters.partition { _1.in == 'path' } if operation.parameters

    {
      path_params: path_params.map(&:name),
      query_params: query_params.map(&:name),
    }
  end

  def api_method_request_body_parameters(operation)
    required = []
    optional = []

    if operation.request_body
      schema = operation.request_body.content['application/json'].schema

      if schema.type == 'array'
        schema.items.properties.map { |name, _| required << [name, schema.items.properties[name]] }
      else
        schema_data =
          if schema.all_of.present?
            [schema.all_of.map(&:properties).flatten, schema.all_of.map(&:required).flatten]
          else
            [schema.properties, schema.required]
          end
        schema_data => [schema_properties, schema_required]

        required, optional = schema_properties.partition { |name, _| schema_required&.include?(name) }
      end
    end

    {
      required: required.map(&:first),
      optional: optional.map(&:first),
    }
  end

  def api_method_name(api_module_name, operation)
    operation
      .operation_id
      .delete_prefix(
        case api_module_name.to_sym
        when :DedicatedVirtualAccount
          'dedicatedAccount'
        when :TransferRecipient
          'transferrecipient'
        else
          api_module_name.camelize(:lower)
        end,
      )
      .delete_prefix('_')
      .underscore
  end

  def existing_api_modules
    @existing_api_modules ||= PaystackGateway.api_modules.to_set { |api_module| api_module.name.split('::').last }
  end

  def tags_by_name
    @tags_by_name ||= @document.raw_schema['tags'].index_by { _1['name'] }
  end

  def document
    @document ||= OpenAPIParser.parse(YAML.load_file(OPENAPI_SPEC), strict_reference_validation: true)
  end
end

OpenApiGenerator.new.generate
