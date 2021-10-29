# frozen_string_literal: true

module Api
  module V1
    module Me
      # Reasons Controller
      class ReasonsController < Api::V1::Me::ApplicationController
        self.operation_class = {
          index: Paw::Operations::Api::Finder,
          show: Paw::Operations::Api::Finder,
          create: Operations::CurrentLoanOperation,
          update: Paw::Operations::Api::Form
        }.with_indifferent_access

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/reasons',
          method: 'get',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List of reasons per loan',
          tags: [
            'api/v1/me/reasons'
          ],
          success_status: 200,
          error_responses: [400, 401, 422, 500],
          presenter: Presenters::Common::ReasonPresenter
        )

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/reasons',
          method: 'post',
          summary: 'Inserts a reason for the current active loan',
          tags: [
            'api/v1/me/reasons'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::LoanReasonPresenter,
          contract: Contracts::Me::LoanReasonContract
        )

        private

        def fetch_options
          {
            params: params.merge!(page: { size: 0 }),
            model_class: Reason,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Common::ReasonPresenter,
            default_scope: lambda { |query|
              Queries::Me::CurrentUserLoanReasonsQuery.new(query).call(current_user.id)
            }
          }
        end

        def form_options
          {
            params: params,
            current_user: current_user,
            model_class: LoanReason,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::LoanReasonContract,
            presenter_class: Presenters::Me::LoanReasonPresenter
          }
        end
      end
    end
  end
end
