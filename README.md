# PaystackGateway

`paystack-gateway` is a Ruby library that provides easy-to-use bindings for the [Paystack API](https://paystack.com/docs/api/). This library provides a collection of modules, methods and helpers for interacting with Paystack's API endpoints. It includes built-in error handling, caching, parsing, and logging.

## Installation
Install the gem and add to the application's Gemfile by executing:

```bash
$ bundle add paystack-gateway
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
$ gem install paystack-gateway
```

## Configuration

To use the PaystackGateway gem, you need to configure it with your Paystack secret key. You can do this in an initializer or directly in your application code.

The configuration options are
- `secret_key`: Your paystack api key used to authorize requests
- `logger`: Your ruby Logger. Default is `Logger.new($stdout)`
- `logging_options`:  Options passed to [Faraday logger middleware](https://github.com/lostisland/faraday/blob/main/lib/faraday/response/logger.rb). Default is `{ headers: false }`
- `log_filter`: Filter used when logging headers and body.
- `use_extensions`: Enable extension modules that add useful helper methods to response and error objects. Default is `true`.

```ruby
# config/initializers/paystack_gateway.rb

PaystackGateway.configure do |config|
  config.secret_key = Rails.application.credentials.dig(:paystack, :secret_key)
  config.logger = Rails.logger
  config.log_filter = lambda { |params|
    next params if !params || !params.respond_to?(:each)

    ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters).filter(params)
  }
end
```

## Usage

Once configured, you can begin utilising the various API modules and methods provided by the gem.
```irb
:001 > r = PaystackGateway::Customer.fetch(code: 'test@example.com')
  I, [2025-03-30T19:53:06.951015 #29623]  INFO -- : request: GET https://api.paystack.co/customer/test@example.com
  I, [2025-03-30T19:53:07.486206 #29623]  INFO -- : response: Status 200
  =>
  {:status=>true,
  ...
:002 > r.class
 => PaystackGateway::Customer::FetchResponse
:003 > r.customer_code
  => "CUS_xsrozmbt8g1oear"
```

### API Organisation

The code is generated directly from [Paystack's OpenAPI specification](https://github.com/PaystackOSS/openapi), ensuring that it mirrors Paystack’s API organisation accurately. Refer to the API documentation for detailed schemas and available options for each endpoint.

- **API Modules**: Each API tag in the Paystack documentation becomes a module under `PaystackGateway`. For example, the Transaction API is accessible via `PaystackGateway::Transaction`.
- **API Methods**: Each operation within a tag is implemented as a method in the corresponding module. For instance, to verify a transaction, you call `PaystackGateway::Transaction.verify`.

### Parameters

All API parameters are implemented as method arguments:

- **Path parameters**: Required parameters in the URL path (e.g., `reference` in `/transaction/verify/{reference}`)
- **Query parameters**: Optional parameters for GET requests (e.g., `from`, `to` in `/transaction/totals`)
- **Request body parameters**: Parameters sent in the request body for POST/PUT requests

Required parameters are clearly marked in the method signatures, while optional parameters typically default to `nil`.

### Responses

Each API method returns a specific response object. For example, when you call `PaystackGateway::Transaction.verify`, you will receive either:

- `PaystackGateway::Transaction::VerifyResponse`, which indicates a successful call.
- `PaystackGateway::Transaction::VerifyError`, which is raised if the call fails.

Paystack responses usually include the main payload nested in the `data` field of the response body. To simplify access, the response objects automatically delegate known attributes from this field, allowing you to reference them directly.

For instance, here’s how you can fetch a customer using the [/customer/{code} endpoint](https://paystack.com/docs/api/customer/#fetch):


```ruby
response = PaystackGateway::Customer.fetch(code: 'CUS_xsrozmbt8g1oear')

# An example of the original response body:
# {:status=>true,
#  :message=>"Customer retrieved",
#  :data=>
#   {"email"=>"test@example.com",
#    "phone"=>"+2348011111111",
#    "customer_code"=>"CUS_xsrozmbt8g1oear",
#    "id"=>203316808,
#    ...

# You can access the attributes directly:
response.id # => 203316808
response.customer_code # => "CUS_xsrozmbt8g1oear"

# Alternatively, you can access them via the data field:
response.data.id # => 203316808
response.data.customer_code # => "CUS_xsrozmbt8g1oear"
```

### Error Handling

Whenever a network error occurs or the called endpoint returns an error response, a `PaystackGateway::ApiError` (or one of its subclasses) is raised, which you can handle in your code. For example, initialising a transaction using the [/transaction/initialize endpoint](https://paystack.com/docs/api/transaction/#initialize) might be done as follows:

```ruby
begin
  response = PaystackGateway::Transaction.initialize_transaction(
    email: 'test@example.com',
    amount: 1000,
    reference: 'test_reference',
  )
  return response.payment_url

rescue InitializeTransactionError => e # subclass of PaystackGateway::ApiError
  cancel_payment if e.cancellable?

rescue PaystackGateway::ApiError => e
  handle_initialize_error(e)
end
```

### Caching

While caching is implemented in the library, it is currently not configurable for all modules and api methods. With a little more work, this can be achieved. So if there's demand for it, I can work on it (PRs are also welcome 🙂).

Some endpoints currently make use of caching:
- Miscellaneous#list_banks
- Verifications#resolve_account_number

Caching works using an [ActiveSupport::Cache::FileStore](https://api.rubyonrails.org/classes/ActiveSupport/Cache/FileStore.html) cache. The default caching period is 7 days and the cache data is stored on the file system at `ENV['TMPDIR']` or `/tmp/cache`.

### Extensions

PaystackGateway includes extension modules that offer additional helper methods on both response and error objects. These modules are enabled by default, so you can immediately benefit from simpler data access and enhanced error handling.

If you prefer to opt out of these enhancements, you can update your configuration as follows:

```ruby
PaystackGateway.configure do |config|
  config.use_extensions = false
end
```

For additional details on the available extensions and helper methods, please refer directly to the source code in the [extensions directory](https://github.com/darthrighteous/paystack-gateway/tree/main/lib/paystack_gateway/extensions).


## Development

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes, add tests for them.
4. Ensure the tests and linter pass
5. Open a pull request with a detailed description of your changes.

### Setting up

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Running the tests and linter

Minitest is used for unit tests. Rubocop is used to enforce the ruby style.

To run the complete set of tests and linter run the following:

```bash
$ bin/setup
$ bin/test
$ bin/lint
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/darthrighteous/paystack-gateway. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[darthrighteous/paystackgateway/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct
Everyone interacting in the PaystackGateway project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[darthrighteous/paystackgateway/blob/master/CODE_OF_CONDUCT.md).
