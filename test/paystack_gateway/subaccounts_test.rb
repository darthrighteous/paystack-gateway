# frozen_string_literal: true

require 'test_helper'

class SubaccountsTest < Minitest::Test
  def test_create_subaccount_fails_without_business_name
    VCR.use_cassette('subaccounts/create_subaccount_failure') do
      error = assert_raises PaystackGateway::ApiError do
        PaystackGateway::Subaccounts.create_subaccount(
          business_name: '',
          settlement_bank: '057',
          account_number: '0000000000',
          percentage_charge: 0,
        )
      end

      assert_match /server.*responded.*400.*"Business name is required.*/, error.message
    end
  end

  def test_create_subaccount_success
    VCR.use_cassette('subaccounts/create_subaccount_success') do
      response = PaystackGateway::Subaccounts.create_subaccount(
        business_name: 'Test Business',
        settlement_bank: '057',
        account_number: '0000000000',
        percentage_charge: 0,
      )

      assert_instance_of PaystackGateway::Subaccounts::CreateSubaccountResponse, response

      assert_equal 'ACCT_ynilx6bhxhgtk0p', response.subaccount_code
    end
  end

  def test_update_subaccount_fails_with_invalid_account_number
    VCR.use_cassette('subaccounts/update_subaccount_failure') do
      error = assert_raises PaystackGateway::ApiError do
        PaystackGateway::Subaccounts.update_subaccount(
          'ACCT_ynilx6bhxhgtk0p',
          business_name: 'Test Business Updated',
          settlement_bank: '057',
          account_number: 'crapshoot1',
          percentage_charge: '50',
        )
      end

      assert_match /server.*responded.*400.*Account details are invalid.*/, error.message
    end
  end

  def test_update_subaccount_success
    VCR.use_cassette('subaccounts/update_subaccount_success') do
      response = PaystackGateway::Subaccounts.update_subaccount(
        'ACCT_ynilx6bhxhgtk0p',
        business_name: 'Test Business Updated',
        settlement_bank: '057',
        account_number: '0000000000',
        percentage_charge: '50',
      )

      assert response.status
      assert 'Test Business Updated', response.data.business_name
      assert 'ACCT_ynilx6bhxhgtk0p', response.subaccount_code
    end
  end
end
