# frozen_string_literal: true

require 'test_helper'

class PlansTest < Minitest::Test
  def test_create_plan_fails_without_name
    VCR.use_cassette('plans/create_plan_failure') do
      error = assert_raises PaystackGateway::ApiError do
        PaystackGateway::Plans.create_plan(name: '', amount: 1, interval: :monthly)
      end

      assert_match(/server.*responded.*400.*name.*empty.*/, error.message)
      assert_equal 400, error.original_error.response_status
    end
  end

  def test_create_plan_success
    VCR.use_cassette('plans/create_plan_success') do
      response = PaystackGateway::Plans.create_plan(name: 'test plan', amount: 100, interval: :monthly)

      assert_instance_of PaystackGateway::Plans::CreatePlanResponse, response

      assert_equal 1_848_188, response.id
      assert_equal 1_848_188, response.plan_id
      assert_equal 'PLN_ze8gkd19w1i1gsf', response.plan_code
    end
  end

  def test_list_plans_success
    VCR.use_cassette('plans/list_plans_success') do
      response = PaystackGateway::Plans.list_plans

      assert_instance_of PaystackGateway::Plans::ListPlansResponse, response

      refute_empty response.data
      refute_empty response.active_plans
      assert_equal 'PLN_ze8gkd19w1i1gsf', response.find_active_plan_by_name('test plan').plan_code
    end
  end

  def test_fetch_plan_fails_with_invalid_plan_code
    VCR.use_cassette('plans/fetch_plan_failure') do
      error = assert_raises PaystackGateway::ApiError do
        PaystackGateway::Plans.fetch_plan(code: 'fake_plan_code')
      end

      assert_match(/server.*responded.*404.*Plan ID.*code.*is invalid.*/, error.message)
      assert_equal 404, error.original_error.response_status
    end
  end

  def test_fetch_plan_success
    VCR.use_cassette('plans/fetch_plan_success') do
      response = PaystackGateway::Plans.fetch_plan(code: 'PLN_ze8gkd19w1i1gsf')

      assert_instance_of PaystackGateway::Plans::FetchPlanResponse, response

      assert_empty response.subscriptions
      assert_empty response.active_subscriptions
      assert_empty response.active_subscription_codes
    end
  end

  def test_update_plan_fails_with_invalid_plan_code
    VCR.use_cassette('plans/update_plan_failure') do
      error = assert_raises PaystackGateway::ApiError do
        PaystackGateway::Plans.update_plan(code: 'fake_plan_code', amount: 1200, interval: :annually)
      end

      assert_match(/server.*responded.*400.*Plan ID.*code.*is invalid.*/, error.message)
      assert_equal 400, error.original_error.response_status
    end
  end

  def test_update_plan_success
    VCR.use_cassette('plans/update_plan_success') do
      response = PaystackGateway::Plans.update_plan(code: 'PLN_ze8gkd19w1i1gsf', amount: 1200, interval: :annually)

      assert_instance_of PaystackGateway::Plans::UpdatePlanResponse, response
      assert response.status
    end
  end
end
