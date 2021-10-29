# frozen_string_literal: true

module Api
  module V1
    module Algorithm
      # Algorithm Loan Movements Controller
      class LoanMovementsController < Api::V1::Algorithm::ApplicationController
        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/algorithm/users/:user_id/loans/:loan_id/loan_movements',
          method: 'get',
          collection: false,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'Lists loan movements for a loan.',
          tags: [
            'api/v1/algorithm/users'
          ],
          success_status: 200,
          error_responses: [400, 401, 404, 422, 500],
          presenter: Presenters::Common::ListOfLoanMovementsPresenter
        )

        def index
          response = Operations::Algorithm::GetLoanMovementsOperation.call(
            fetch_options
          )
          render json: response[:response], status: response[:status]
        end

        private

        def fetch_options
          {
            params: params,
            presenter_class: Presenters::Common::ListOfLoanMovementsPresenter
          }
        end
      end
    end
  end
end
