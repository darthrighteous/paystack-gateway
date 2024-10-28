# frozen_string_literal: true

require_relative 'lib/paystack_gateway/version'

Gem::Specification.new do |spec|
  spec.name = 'paystack-gateway'
  spec.version = PaystackGateway::VERSION
  spec.authors = ['darthrighteous']
  spec.email = ['ja.ogunniyi@gmail.com']

  spec.summary = 'Ruby bindings for Paystack’s API https://paystack.com/docs/api'
  spec.description =
    'Library providing a collection of easy-to-use modules, methods, and helpers
    for interacting with Paystack’s API endpoints. Includes built-in error
    handling, response parsing and logging. See official paystack docs
    https://paystack.com/docs/api/'

  spec.homepage = 'https://github.com/darthrighteous/paystackgateway'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/darthrighteous/paystackgateway'
  spec.metadata['changelog_uri'] = 'https://github.com/darthrighteous/paystackgateway/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # spec.add_dependency "example-gem", "~> 1.0"
  # spec.add_dependency 'activesupport', '>= 5.0'
end
