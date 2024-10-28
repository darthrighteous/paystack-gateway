# frozen_string_literal: true

module PaystackGateway
  # Create and manage installment payment options
  # https://paystack.com/docs/api/plan/#create
  module Plans
    include PaystackGateway::RequestModule

    # Response from POST /plan endpoint.
    class CreatePlanResponse < PaystackGateway::Response
      delegate :id, to: :data, prefix: :plan
      delegate :id, :plan_code, to: :data
    end

    api_method def self.create_plan(name:, amount:, interval:)
      with_response(CreatePlanResponse) do |connection|
        connection.post(
          '/plan',
          {
            name:,
            interval:,
            amount: amount * 100,
            send_invoices: false,
            send_sms: false,
          },
        )
      end
    end

    # Response from GET /plan endpoint.
    class ListPlansResponse < PaystackGateway::Response
      def active_plans = data.select { |plan| !plan.is_deleted && !plan.is_archived }

      def find_active_plan_by_name(name)
        active_plans.sort_by { -Time.parse(_1.createdAt).to_i }.find { _1.name == name }
      end
    end

    api_method def self.list_plans
      with_response(ListPlansResponse) do |connection|
        connection.get('/plan')
      end
    end

    # Response from GET /plan/:code endpoint.
    class FetchPlanResponse < PaystackGateway::Response
      delegate :subscriptions, to: :data

      def active_subscriptions = subscriptions.select { _1.status.to_sym == :active }

      def active_subscription_codes(email: nil)
        subscriptions =
          if email
            active_subscriptions.select { _1.customer.email.casecmp?(email) }
          else
            active_subscriptions
          end
        subscriptions.map(&:subscription_code)
      end
    end

    api_method def self.fetch_plan(code:)
      with_response(FetchPlanResponse) do |connection|
        connection.get("/plan/#{code}")
      end
    end

    class UpdatePlanResponse < PaystackGateway::Response; end

    api_method def self.update_plan(code:, amount:, interval:)
      with_response(UpdatePlanResponse) do |connection|
        connection.put(
          "/plan/#{code}",
          {
            amount: amount * 100,
            interval:,
          },
        )
      end
    end
  end
end
