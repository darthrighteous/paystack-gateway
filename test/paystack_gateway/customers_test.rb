# frozen_string_literal: true

require 'test_helper'

class CustomersTest < Minitest::Test
  def test_create_customer_fails_with_invalid_email
    VCR.use_cassette 'customers/create_customer_failure' do
      error = assert_raises PaystackGateway::ApiError do
        PaystackGateway::Customers.create_customer(email: 'fakeemail', first_name: nil, last_name: nil)
      end

      assert_match /server.*responded.*400.*must be a valid email.*/, error.message
      assert_equal 400, error.original_error.response_status
    end
  end

  def test_create_customer_success
    VCR.use_cassette('customers/create_customer_success') do
      response =
        PaystackGateway::Customers.create_customer(email: 'test@example.com', first_name: 'Test', last_name: 'User')

      assert_instance_of PaystackGateway::Customers::CreateCustomerResponse, response

      assert_equal 203316808, response.id
      assert_equal 'CUS_xsrozmbt8g1oear', response.customer_code
    end
  end

  def test_fetch_customer_fails_with_unknown_email
    VCR.use_cassette('customers/fetch_customer_failure') do
      error = assert_raises PaystackGateway::ApiError do
        PaystackGateway::Customers.fetch_customer(email: 'fakeemail@unknown.com')
      end

      assert_match /server.*responded.*404.*Customer not found.*/, error.message
      assert_equal 404, error.original_error.response_status
    end
  end

  def test_fetch_customer_success
    VCR.use_cassette('customers/fetch_customer_success') do
      response =
        PaystackGateway::Customers.fetch_customer(email: 'test@example.com')

      assert_instance_of PaystackGateway::Customers::FetchCustomerResponse, response

      assert_equal 203316808, response.id
      assert_equal 'CUS_xsrozmbt8g1oear', response.customer_code

      assert_empty response.subscriptions
      assert_empty response.active_subscriptions
      assert_empty response.active_subscription_codes
      assert_empty response.authorizations
      assert_empty response.reusable_authorizations
    end
  end
end
