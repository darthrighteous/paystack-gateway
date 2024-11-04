# frozen_string_literal: true

require 'test_helper'

class DedicatedVirtualAccountsTest < Minitest::Test
  def test_create_dedicated_virtual_account_fails_with_invalid_customer
    VCR.use_cassette('dedicated_virtual_accounts/create_dedicated_virtual_account_failure') do
      error = assert_raises PaystackGateway::ApiError do
        PaystackGateway::DedicatedVirtualAccounts.create_dedicated_virtual_account(
          customer_id_or_code: 'fake',
          subaccount_code: nil,
          preferred_bank: nil,
        )
      end

      assert_match(/server.*responded.*400.*Invalid value.*customer.*/, error.message)
      assert_equal 400, error.original_error.response_status
    end
  end

  def test_create_dedicated_virtual_account_success
    VCR.use_cassette('dedicated_virtual_accounts/create_dedicated_virtual_account_success') do
      response =
        PaystackGateway::DedicatedVirtualAccounts.create_dedicated_virtual_account(
          customer_id_or_code: 'CUS_xsrozmbt8g1oear',
          subaccount_code: nil,
          preferred_bank: nil,
        )

      assert_instance_of PaystackGateway::DedicatedVirtualAccounts::CreateDedicatedVirtualAccountResponse, response

      assert_equal 'Test Bank', response.data.bank.name
      assert_equal 'TEST-MANAGED-ACCOUNT', response.data.account_name
      assert_equal '1238221259', response.data.account_number
    end
  end

  def test_assign_dedicated_virtual_account_fails_with_invalid_email
    VCR.use_cassette('dedicated_virtual_accounts/assign_dedicated_virtual_account_failure') do
      error = assert_raises PaystackGateway::ApiError do
        PaystackGateway::DedicatedVirtualAccounts.assign_dedicated_virtual_account(
          email: 'fakemail',
          first_name: 'Test2',
          last_name: 'User',
          subaccount_code: nil,
          preferred_bank: nil,
        )
      end

      assert_match(/server.*responded.*400.*must be a valid email.*/, error.message)
      assert_equal 400, error.original_error.response_status
    end
  end

  def test_assign_dedicated_virtual_account_success
    VCR.use_cassette('dedicated_virtual_accounts/assign_dedicated_virtual_account_success') do
      response =
        PaystackGateway::DedicatedVirtualAccounts.assign_dedicated_virtual_account(
          email: 'test2@example.com',
          first_name: 'Test2',
          last_name: 'User',
          subaccount_code: nil,
          preferred_bank: nil,
        )

      assert_instance_of PaystackGateway::DedicatedVirtualAccounts::AssignDedicatedVirtualAccountResponse, response

      assert response.status
      assert_equal 'Assign dedicated account in progress', response.message
    end
  end

  # Disable temporarily, it fails even though values are valid
  def xtest_split_dedicated_account_transaction_fails_with_invalid_customer
    VCR.use_cassette('dedicated_virtual_accounts/split_dedicated_account_transaction_failure') do
      error = assert_raises PaystackGateway::ApiError do
        PaystackGateway::DedicatedVirtualAccounts.split_dedicated_account_transaction(
          customer_id_or_code: 'CUS_xsrozmbt8g1oear',
          subaccount_code: 'ACCT_ynilx6bhxhgtk0p',
        )
      end

      assert_match(/server.*responded.*400.*Invalid value.*customer.*/, error.message)
      assert_equal 400, error.original_error.response_status
    end
  end

  # Disable temporarily, it fails even though values are valid
  def xtest_split_dedicated_account_transaction_success
    VCR.use_cassette('dedicated_virtual_accounts/split_dedicated_account_transaction_success') do
      response = PaystackGateway::DedicatedVirtualAccounts.split_dedicated_account_transaction(
        customer_id_or_code: 'CUS_xsrozmbt8g1oear',
        subaccount_code: 'ACCT_ynilx6bhxhgtk0p',
      )

      assert_instance_of PaystackGateway::DedicatedVirtualAccounts::SplitDedicatedAccountTransactionResponse, response

      assert response.status
    end
  end

  def test_requery_dedicated_account_fails_with_invalid_account
    VCR.use_cassette('dedicated_virtual_accounts/requery_dedicated_account_failure') do
      response = PaystackGateway::DedicatedVirtualAccounts.requery_dedicated_account(
        account_number: 'FAKEACC',
        bank: 'fake-bank',
      )

      # Turns out paystack will give you successful response regardless of the
      # invalid account number and bank
      assert_empty response.data
      assert response.status
    end
  end

  def test_requery_dedicated_account_success
    VCR.use_cassette('dedicated_virtual_accounts/requery_dedicated_account_success') do
      response = PaystackGateway::DedicatedVirtualAccounts.requery_dedicated_account(
        account_number: '0000000000',
        bank: 'test-bank',
      )

      assert_instance_of PaystackGateway::DedicatedVirtualAccounts::RequeryDedicatedAccountResponse, response

      assert response.status
    end
  end
end
