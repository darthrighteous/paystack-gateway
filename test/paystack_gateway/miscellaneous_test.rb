# frozen_string_literal: true

require 'test_helper'

class MiscellaneousTest < Minitest::Test
  def test_list_banks_success
    VCR.use_cassette('miscellaneous/list_banks_success') do
      response = PaystackGateway::Miscellaneous.list_banks

      assert_instance_of PaystackGateway::Miscellaneous::ListBanksResponse, response

      assert response.status
      refute_empty response.data
      refute_empty response.bank_names
      refute_empty response.bank_slugs
      refute_empty response.by_bank_names
      refute_empty response.by_bank_codes

      assert_equal %w[id name], response.bank_details(:id, :name).first.keys
    end
  end
end
