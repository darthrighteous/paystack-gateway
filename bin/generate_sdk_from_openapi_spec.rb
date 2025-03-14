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

def update_required_files(module_names)
  file_lines = File.readlines(LIB_FILE)

  comment_start_index = file_lines.find_index { |line| line.include?('# API Modules') }
  if !comment_start_index
    puts "Could not find '# API Modules' comment in #{LIB_FILE}"
    return
  end

  insertion_start = comment_start_index + 1
  insertion_start += 1 while insertion_start < file_lines.size && file_lines[insertion_start].start_with?('#')

  insertion_end = insertion_start
  insertion_end += 1 while insertion_end < file_lines.size && !file_lines[insertion_end].strip.empty?

  file_lines[insertion_start...insertion_end] =
    module_names.map { |module_name| "require 'paystack_gateway/#{module_name.underscore}'\n" }.sort.join

  File.write(LIB_FILE, file_lines.join)

  puts 'Updated paystack_gateway.rb with new API Modules requires.'
end

def api_module_content(api_module_name, api_methods)
  <<~RUBY
    # frozen_string_literal: true

    module PaystackGateway
      #{api_module_docstring(api_module_name)}
      module #{api_module_name}
        include PaystackGateway::RequestModule

    #{api_methods.map { |info| api_method_composition(api_module_name, info) }.join("\n").chomp}
      end
    end
  RUBY
end

def api_module_docstring(api_module_name)
  module_info = tags_by_name[api_module_name]
  return if !module_info

  docstring = "# https://paystack.com/docs/api/#{api_module_name.parameterize}"
  docstring += "\n#{INDENT * 1}#"
  docstring += "\n#{INDENT * 1}# #{module_info['x-product-name'].squish || api_module_name.humanize}"

  docstring += "\n#{INDENT * 1}# #{module_info['description'].squish}" if module_info['description']
  docstring
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

  definition = "#{INDENT * 2}# Successful response from calling ##{api_method_name}.\n"
  definition += "#{INDENT * 2}class #{"#{api_method_name}_response".camelize} < PaystackGateway::Response"

  if (success_response = responses[responses.keys.find { _1.match?(/\A2..\z/) }]) &&
     (required_data_keys = success_response.content['application/json'].schema.properties['data']&.required)

    required_data_keys -= %w[status message data meta]
    if required_data_keys.length > 3
      definition += "\n#{INDENT * 3}delegate :#{required_data_keys.shift},"

      while (line_key = required_data_keys.shift).present?
        definition += "\n#{INDENT * 3}#{' ' * 'delegate'.length} :#{line_key},"
      end
      definition += ' to: :data'
    else
      definition += "\n#{INDENT * 3}delegate #{required_data_keys.map { |key| ":#{key}" }.join(', ')}, to: :data"
    end

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
    #{api_method_definition_docstring(api_method_name, operation, http_method, path)}
    #{api_method_definition_name_and_parameters(api_method_name, operation)}
      use_connection do |connection|
        connection.#{http_method}(
          #{api_method_definition_path(path)},#{api_method_definition_request_params(operation)}
        )
      end
    end
  RUBY
end

def api_method_definition_docstring(api_method_name, operation, http_method, path)
  docstring = "# https://paystack.com/docs/api/#{operation.tags.first.parameterize}/##{api_method_name}"
  docstring += "\n#{INDENT * 2}# #{operation.summary}: #{http_method.upcase} #{path}"
  docstring += "\n#{INDENT * 2}# #{operation.description}" if operation.description.present?
  docstring += "\n#{INDENT * 2}#"

  api_method_parameters(operation).each do |param|
    docstring += "\n#{INDENT * 2}# @param #{param[:name]} [#{param[:type]}]"
    docstring += ' (required)' if param[:required]

    if (description = param[:description]&.squish)
      docstring += wrapped_text(description, "\n#{INDENT * 2}##{INDENT * 3} ")
    end

    next if !(object_properties = param[:object_properties])

    object_properties.each do |props|
      docstring += "\n#{INDENT * 2}##{INDENT * 1} @option #{param[:name]} [#{props[:type]}] :#{props[:name]}"
      docstring += wrapped_text(props[:description], "\n#{INDENT * 2}##{INDENT * 5}")
    end
  end

  docstring += "\n#{INDENT * 2}# @return [#{"#{api_method_name}_response".camelize}] successful response"
  docstring + "\n#{INDENT * 2}# @raise [#{"#{api_method_name}_error".camelize}] if the request fails"
end

def api_method_definition_name_and_parameters(api_method_name, operation)
  method_args = api_method_parameters(operation).map do |param|
    param[:required] ? "#{param[:name]}:" : "#{param[:name]}: nil"
  end

  definition = "api_method def self.#{api_method_name}"
  return definition if method_args.none?

  definition += '('

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
  params = api_method_parameters(operation)
             .reject { |param| param[:in] == 'path' }
             .map { |param| param[:name] }
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

update_required_files(module_names)
