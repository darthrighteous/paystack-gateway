# frozen_string_literal: true

module PaystackGateway
  module Extensions
    # Helpers for PaystackGateway::Plan
    module PlanExtensions
      # Helpers for PaystackGateway::Plan::CreateResponse
      module CreateResponseExtension
        def plan_id = data.id
      end

      # Helpers for PaystackGateway::Plan::ListResponse
      module ListResponseExtension
        def active_plans = data.select { |plan| !plan.is_deleted && !plan.is_archived }

        def find_active_plan_by_name(name)
          active_plans.sort_by { -Time.parse(_1.createdAt).to_i }.find { _1.name == name }
        end
      end

      # Helpers for PaystackGateway::Plan::FetchResponse
      module FetchResponseExtension
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
    end
  end
end

if PaystackGateway.use_extensions
  PaystackGateway::Plan::ListResponse.include(
    PaystackGateway::Extensions::PlanExtensions::ListResponseExtension,
  )

  PaystackGateway::Plan::CreateResponse.include(
    PaystackGateway::Extensions::PlanExtensions::CreateResponseExtension,
  )

  PaystackGateway::Plans::FetchPlanResponse.include(
    PaystackGateway::Extensions::PlanExtensions::FetchResponseExtension,
  )
end
