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
- `logger`: Your ruby Logger. Default is Logger.new($stdout)
- `logging_options`:  Options passed to [Faraday logger middleware](https://github.com/lostisland/faraday/blob/main/lib/faraday/response/logger.rb). Default is `{ headers: false }`
- `log_filter`: Filter used when logging headers and body.

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

### Calling API endpoints
Once configured, you can start using the various API modules and methods provided by the gem. They are designed to mirror how the api methods are grouped and listed on the [Paystack API](https://paystack.com/docs/api/).

Here's an example creating a customer using the [/customer/create endpoint](https://paystack.com/docs/api/customer/#create).

```ruby
response = PaystackGateway::Customers.create_customer(
  email: 'test@example.com',
  first_name: 'Test',
  last_name: 'User',
)

response.id # => 203316808
response.customer_code # => "CUS_xsrozmbt8g1oear"
```

### Error Handling
Whenever a network error occurs or the called endpoint responds with an error response, a `PaystackGateway::ApiError`(or a subclass of it) is raised that can be handled in your calling code.

Here's an example initializing a transaction using the [/transaction/initialize endpoint](https://paystack.com/docs/api/transaction/#initialize)

```ruby
begin
  response = PaystackGateway::Transactions.initialize_transaction(
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


## API Modules and Methods
> Refer to the [Paystack API documentation](https://paystack.com/docs/api) for details on all the available endpoints and their usage.

### Implemented Modules and Methods

Below is a complete list of the API modules and methods that are currently implemented.

I invite you to collaborate on this project! If you need to use any of the unimplemented API methods or modules, or if you want to make modifications to the defaults or the level of configuration available in the currently implemented API methods, please feel free to raise a pull request (PR). See [Contributing](#contributing) and [Code of Conduct](#code-of-conduct) below

- [x] [Transactions](https://paystack.com/docs/api/transaction/)
  - [x] [Initialize Transaction](https://paystack.com/docs/api/transaction/#initialize)
  - [x] [Verify Transaction](https://paystack.com/docs/api/transaction/#verify)
  - [ ] [List Transactions](https://paystack.com/docs/api/transaction/#list)
  - [ ] [Fetch Transaction](https://paystack.com/docs/api/transaction/#fetch)
  - [x] [Charge Authorization](https://paystack.com/docs/api/transaction/#charge-authorization)
  - [ ] [View Transaction Timeline](https://paystack.com/docs/api/transaction/#view-timeline)
  - [ ] [Transaction Totals](https://paystack.com/docs/api/transaction/#totals)
  - [ ] [Export Transactions](https://paystack.com/docs/api/transaction/#export)
  - [ ] [Partial Debit](https://paystack.com/docs/api/transaction/#partial-debit)

- [ ] [Customers](https://paystack.com/docs/api/customer/)
  - [x] [Create Customer](https://paystack.com/docs/api/customer/#create)
  - [ ] [List Customers](https://paystack.com/docs/api/customer/#list)
  - [x] [Fetch Customer](https://paystack.com/docs/api/customer/#fetch)
  - [ ] [Update Customer](https://paystack.com/docs/api/customer/#update)
  - [ ] [Validate Customer](https://paystack.com/docs/api/customer/#validate)
  - [ ] [Whitelist/Blacklist Customer](https://paystack.com/docs/api/customer/#whitelist-blacklist)
  - [ ] [Deactivate Authorization](https://paystack.com/docs/api/customer/#deactivate-authorization)

- [x] [Dedicated Virtual Accounts](https://paystack.com/docs/api/dedicated-virtual-account/)
  - [x] [Create Dedicated Virtual Account](https://paystack.com/docs/api/dedicated-virtual-account/#create)
  - [x] [Assign Dedicated Virtual Account](https://paystack.com/docs/api/dedicated-virtual-account/#assign)
  - [ ] [List Dedicated Accounts](https://paystack.com/docs/api/dedicated-virtual-account/#list)
  - [ ] [Fetch Dedicated Account](https://paystack.com/docs/api/dedicated-virtual-account/#fetch)
  - [x] [Requery Dedicated Account](https://paystack.com/docs/api/dedicated-virtual-account/#requery)
  - [ ] [Deactivate Dedicated Account](https://paystack.com/docs/api/dedicated-virtual-account/#deactivate)
  - [x] [Split Dedicated Account Transaction](https://paystack.com/docs/api/dedicated-virtual-account/#add-split)
  - [ ] [Remove Split from Dedicated Account](https://paystack.com/docs/api/dedicated-virtual-account/#remove-split)
  - [ ] [Fetch Bank Providers](https://paystack.com/docs/api/dedicated-virtual-account/#providers)

- [ ] [Subaccounts](https://paystack.com/docs/api/subaccount/)
  - [x] [Create Subaccount](https://paystack.com/docs/api/subaccount/#create)
  - [ ] [List Subaccounts](https://paystack.com/docs/api/subaccount/#list)
  - [ ] [Fetch Subaccount](https://paystack.com/docs/api/subaccount/#fetch)
  - [x] [Update Subaccount](https://paystack.com/docs/api/subaccount/#update)

- [x] [Plans](https://paystack.com/docs/api/plan/)
  - [x] [Create Plan](https://paystack.com/docs/api/plan/#create)
  - [x] [List Plans](https://paystack.com/docs/api/plan/#list)
  - [x] [Fetch Plan](https://paystack.com/docs/api/plan/#fetch)
  - [x] [Update Plan](https://paystack.com/docs/api/plan/#update)

- [x] [Transfer Recipients](https://paystack.com/docs/api/transfer-recipient/)
  - [x] [Create Transfer Recipient](https://paystack.com/docs/api/transfer-recipient/#create)
  - [ ] [Bulk Create Transfer Recipient](https://paystack.com/docs/api/transfer-recipient/#bulk)
  - [ ] [List Transfer Recipients](https://paystack.com/docs/api/transfer-recipient/#list)
  - [ ] [Fetch Transfer Recipient](https://paystack.com/docs/api/transfer-recipient/#fetch)
  - [ ] [Update Transfer Recipient](https://paystack.com/docs/api/transfer-recipient/#update)
  - [ ] [Delete Transfer Recipient](https://paystack.com/docs/api/transfer-recipient/#delete)

- [x] [Transfers](https://paystack.com/docs/api/transfer/)
  - [x] [Initiate Transfer](https://paystack.com/docs/api/transfer/#initiate)
  - [ ] [Finalize Transfer](https://paystack.com/docs/api/transfer/#finalize)
  - [ ] [Initiate Bulk Transfer](https://paystack.com/docs/api/transfer/#bulk)
  - [ ] [List Transfers](https://paystack.com/docs/api/transfer/#list)
  - [ ] [Fetch Transfer](https://paystack.com/docs/api/transfer/#fetch)
  - [x] [Verify Transfer](https://paystack.com/docs/api/transfer/#verify)

- [x] [Refunds](https://paystack.com/docs/api/refund/)
  - [x] [Create Refund](https://paystack.com/docs/api/refund/#create)
  - [x] [List Refunds](https://paystack.com/docs/api/refund/#list)
  - [x] [Fetch Refund](https://paystack.com/docs/api/refund/#fetch)

- [x] [Verification](https://paystack.com/docs/api/verification/)
  - [x] [Resolve Account Number](https://paystack.com/docs/api/verification/#resolve-account)
  - [ ] [Validate Account](https://paystack.com/docs/api/verification/#validate-account)
  - [ ] [Resolve Card BIN](https://paystack.com/docs/api/verification/#resolve-card)

- [x] [Miscellaneous](https://paystack.com/docs/api/miscellaneous/)
  - [x] [List Banks](https://paystack.com/docs/api/miscellaneous/#bank)
  - [ ] [List/Search Countries](https://paystack.com/docs/api/miscellaneous/#country)
  - [ ] [List States (AVS)](https://paystack.com/docs/api/miscellaneous/#avs-states)


## Development

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes, add tests for them.
4. Ensure the tests and linter pass
5. Open a pull request with a detailed description of your changes.

### Setting up

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Running the tests and linter

Minitest is used for unit tests. Rubocop is used to enforce the ruby style.

To run the complete set of tests and linter run the following:

```bash
$ bundle install
$ bundle exec rake test
$ bundle exec rubocop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/darthrighteous/paystack-gateway. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[darthrighteous/paystackgateway/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct
Everyone interacting in the PaystackGateway project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[darthrighteous/paystackgateway/blob/master/CODE_OF_CONDUCT.md).
