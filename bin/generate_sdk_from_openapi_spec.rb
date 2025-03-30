#!/usr/bin/env ruby
# frozen_string_literal: true

require 'openapi_parser'
require 'paystack_gateway'
require 'debug'

SDK_ROOT = File.expand_path('..', __dir__)
LIB_DIR = File.join(SDK_ROOT, 'lib', 'paystack_gateway')
LIB_FILE = File.join(SDK_ROOT, 'lib', 'paystack_gateway.rb')
OPENAPI_SPEC = File.join(SDK_ROOT, 'openapi', 'base', 'paystack.yaml')
INDENT = '  '
WRAP_LINE_LENGTH = 80
TOP_LEVEL_RESPONSE_KEYS = %w[status message data meta].freeze

def api_module_content(api_module_name, api_methods) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
  module_info = tags_by_name[api_module_name]
  <<~RUBY
    # frozen_string_literal: true

    module PaystackGateway
      # https://paystack.com/docs/api/#{api_module_name.parameterize}
      #
      # #{module_info['x-product-name'].squish || api_module_name.humanize}
      # #{module_info['description'].squish}
      module #{api_module_name}
        include PaystackGateway::RequestModule

    #{
      api_methods.map do |api_method_info| # rubocop:disable Metrics/BlockLength
        api_method_info => { path:, http_method:, operation: }

        api_method_name = api_method_name(api_module_name, operation)
        <<~RUBY.chomp
          #{INDENT * 2}# Successful response from calling ##{api_method_name}.
          #{INDENT * 2}class #{"#{api_method_name}_response".camelize} < PaystackGateway::Response#{
            if (data_keys = api_response_data_keys(operation)).any?
              if data_keys.length > 3
                "\n#{INDENT * 3}delegate #{data_keys.map { |key| ":#{key}," }.join("\n#{INDENT * 3} #{' ' * 'delegate'.length}")} to: :data\n#{INDENT * 2}end"
              else
                "\n#{INDENT * 3}delegate #{data_keys.map { |key| ":#{key}" }.join(', ')}, to: :data\n#{INDENT * 2}end"
              end
            else
              '; end'
            end
          }

          #{INDENT * 2}# Error response from ##{api_method_name}.
          #{INDENT * 2}class #{"#{api_method_name}_error".camelize} < ApiError; end

          #{INDENT * 2}# https://paystack.com/docs/api/#{operation.tags.first.parameterize}/##{api_method_name}
          #{INDENT * 2}# #{operation.summary}: #{http_method.upcase} #{path}#{
            operation.description ? "\n#{INDENT * 2}# #{operation.description}" : ''
          }
          #{INDENT * 2}##{
            docstring = ''
            api_method_parameters(operation).each do |param|
              docstring += "\n#{INDENT * 2}# @param #{param[:name]} [#{param[:type]}]"
              docstring += ' (required)' if param[:required]

              if (description = param[:description]&.squish)
                docstring += wrapped_text(description, "\n#{INDENT * 2}##{INDENT * 3} ")
              end

              next if !(object_properties = param[:object_properties])

              object_properties.each do |props|
                docstring += "\n#{INDENT * 2}##{INDENT * 1} @option #{param[:name]} [#{props[:type]}] :#{props[:name]}"
                docstring += wrapped_text(props[:description], "\n#{INDENT * 2}##{INDENT * 5}").to_s
              end
            end

            docstring
          }
          #{INDENT * 2}#
          #{INDENT * 2}# @return [#{"#{api_method_name}_response".camelize}] successful response
          #{INDENT * 2}# @raise [#{"#{api_method_name}_error".camelize}] if the request fails
          #{INDENT * 2}api_method def self.#{api_method_name}#{
            if (method_args = api_method_args(operation)).any?
              if method_args.length > 5
                "(#{method_args.map { |arg| "\n#{INDENT * 3}#{arg}" }.join(',')}\n#{INDENT * 2})"
              else
                "(#{method_args.join(', ')})"
              end
            end
          }
          #{INDENT * 2}  use_connection do |connection|
          #{INDENT * 2}    connection.#{http_method}(
          #{INDENT * 2}      #{
            if path == (interpolated = path.gsub(/{([^}]+)}/, "\#{\\1}"))
              "'#{path}'"
            else
              "\"#{interpolated}\""
            end
          },#{
            if (request_args = api_request_args(operation)).any?
              if request_args.length > 5
                "\n#{INDENT * 5}{#{request_args.map { |arg| "\n#{INDENT * 6}#{arg}," }.join}\n#{INDENT * 5}}.compact,"
              else
                "\n#{INDENT * 5}{ #{request_args.join(', ')} }.compact,"
              end
            end
          }
          #{INDENT * 2}    )
          #{INDENT * 2}  end
          #{INDENT * 2}end

        RUBY
      end.join("\n").chomp
    }
      end
    end
  RUBY
end

def api_response_data_keys(operation)
  responses = operation.responses.response
  success_response = responses[responses.keys.find { _1.match?(/\A2..\z/) }]
  return [] if !success_response

  required_data_keys = success_response.content['application/json'].schema.properties['data']&.required || []
  required_data_keys - TOP_LEVEL_RESPONSE_KEYS
end

def api_method_args(operation)
  api_method_parameters(operation).map do |param|
    name = param[:name].underscore
    param[:required] ? "#{name}:" : "#{name}: nil"
  end
end

def api_request_args(operation)
  api_method_parameters(operation)
    .filter_map do |param|
      next if param[:in] == 'path'

      if param[:name] == param[:name].underscore
        "#{param[:name]}:"
      else
        "#{param[:name]}: #{param[:name].underscore}"
      end
    end
end

def api_method_parameters(operation)
  @api_method_parameters ||= {}
  @api_method_parameters[operation] ||= [
    *api_method_path_and_query_parameters(operation),
    *api_method_request_body_parameters(operation),
  ].sort_by { |param| param[:required] ? 0 : 1 }
end

def api_method_path_and_query_parameters(operation)
  return [] if !operation.parameters

  operation.parameters.map do |param|
    {
      name: param.name,
      in: param.in,
      required: param.in == 'path',
      description: param.description,
      type: schema_type(param.schema),
    }
  end
end

def api_method_request_body_parameters(operation)
  return [] if !operation.request_body

  schema = operation.request_body.content['application/json'].schema
  if schema.type == 'array'
    schema_array_properties(schema)
  else
    schema_object_properties(schema)
  end
end

def schema_object_properties(schema)
  if schema.all_of.present?
    schema_properties = schema.all_of.map(&:properties).reduce(&:merge)
    schema_required = schema.all_of.flat_map(&:required).compact.presence
  else
    schema_properties = schema.properties
    schema_required = schema.required
  end

  schema_properties&.map do |name, p_schema|
    {
      name:,
      in: 'body',
      required: schema_required ? schema_required.include?(name) : true,
      description: schema_description(p_schema),
      type: schema_type(p_schema),
      object_properties: schema_object_properties(p_schema),
    }
  end
end

def schema_array_properties(schema)
  schema.items.properties.map do |name, p_schema|
    {
      name:,
      in: 'body',
      required: true,
      description: schema_description(p_schema),
      type: "Array<#{schema_type(p_schema.items)}>",
      object_properties: schema_object_properties(p_schema.items),
    }
  end
end

def schema_type(schema)
  case schema.type
  when 'array'
    "Array<#{schema_type(schema.items)}>"
  when 'string'
    if schema.format == 'date-time'
      'Time'
    elsif schema.enum
      schema.enum.map { |v| "\"#{v}\"" }.join(', ')
    else
      'String'
    end
  when 'object'
    'Hash'
  when 'integer', 'boolean', 'number'
    schema.type.capitalize
  else
    raise "Unhandled schema type: #{schema.type}"
  end
end

def schema_description(schema)
  schema.description || schema.items&.description
end

def api_method_name(api_module_name, operation)
  name = operation
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

  # initialize is a reserved word in Ruby
  case [api_module_name, name]
  when %w[Transaction initialize]
    'initialize_transaction'
  else
    name
  end
end

def wrapped_text(text, prefix = nil)
  wrapped = ''
  text_words = text.split

  until text_words.none?
    line = ''
    line += " #{text_words.shift}" until text_words.none? || line.length >= WRAP_LINE_LENGTH

    wrapped += "#{prefix}#{line}"
  end

  wrapped
end

def existing_api_modules
  @existing_api_modules ||= PaystackGateway.api_modules.to_set { |api_module| api_module.name.split('::').last }
end

def tags_by_name
  @tags_by_name ||= @document.raw_schema['tags'].index_by { _1['name'].remove(' ') }
end

def document
  @document ||= OpenAPIParser.parse(YAML.load_file(OPENAPI_SPEC), strict_reference_validation: true)
end

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

module_names = api_methods_by_api_module_name.map do |api_module_name, api_methods|
  if existing_api_modules.include?(api_module_name)
    puts "Updating existing module: #{api_module_name}"
  else
    puts "Processing new module: #{api_module_name}"
  end

  content = api_module_content(api_module_name, api_methods)

  file_path = File.join(LIB_DIR, "#{api_module_name.underscore}.rb")
  puts "Writing module content for: #{file_path}"
  File.write(file_path, content)

  api_module_name
end

lib_file_lines = File.readlines(LIB_FILE)

comment_start_index = lib_file_lines.find_index { |line| line.include?('# API Modules') }
if !comment_start_index
  puts "Could not find '# API Modules' comment in #{LIB_FILE}"
  exit 1
end

insertion_start = comment_start_index + 1
insertion_start += 1 while insertion_start < lib_file_lines.size && lib_file_lines[insertion_start].start_with?('#')

insertion_end = insertion_start
insertion_end += 1 while insertion_end < lib_file_lines.size && !lib_file_lines[insertion_end].strip.empty?

lib_file_lines[insertion_start...insertion_end] =
  module_names.map { |module_name| "require 'paystack_gateway/#{module_name.underscore}'\n" }.sort.join

File.write(LIB_FILE, lib_file_lines.join)

puts 'Updated paystack_gateway.rb with new API Modules requires.'
