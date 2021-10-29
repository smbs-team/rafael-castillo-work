# frozen_string_literal: true

module Api
  module V1
    module Me
      # LoanMovements Controller
      class LoanMovementsController < Api::V1::Me::ApplicationController
        self.operation_class = {
          index: Operations::GetLoanMovementsOperation,
          show: Paw::Operations::Api::Finder,
          create: Paw::Operations::Api::Form,
          update: Paw::Operations::Api::Form
        }.with_indifferent_access

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/loans/loan_movements',
          method: 'get',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List movements of the current active loan',
          tags: [
            'api/v1/me/loans'
          ],
          success_status: 200,
          error_responses: [401, 422, 500],
          presenter: Presenters::Common::ListOfLoanMovementsPresenter
        )

        private

        def fetch_options
          {
            params: params,
            current_user: current_user,
            presenter_class: Presenters::Common::ListOfLoanMovementsPresenter
          }
        end
      end
    end
  end
end
