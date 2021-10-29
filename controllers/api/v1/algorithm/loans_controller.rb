# frozen_string_literal: true

module Api
  module V1
    module Algorithm
      # Algorithm Loans Controller
      class LoansController < Api::V1::Algorithm::ApplicationController
        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/algorithm/users/:id/loans',
          method: 'get',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List loans',
          tags: [
            'api/v1/algorithm/users'
          ],
          success_status: 200,
          error_responses: [400, 401, 404, 422, 500],
          presenter: Presenters::Common::LoanPresenter
        )

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/algorithm/users/:id/loans/crowdfund_loan',
          method: 'post',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'Transitions loan to `crowdfunded` and creates mutuos.',
          tags: [
            'api/v1/algorithm/users'
          ],
          success_status: 200,
          error_responses: [400, 401, 404, 422, 500],
          presenter: Presenters::Algorithm::CrowdfundedLoanPresenter,
          contract: Contracts::Algorithm::CrowdfundLoanContract
        )
        def crowdfund
          response = Operations::CrowdfundLoanOperation.call(
            form_options_for_crowdfund
          )

          render json: response[:response], status: response[:status]
        end

        private

        def fetch_options
          {
            params: params.merge!(filter: { user_id_eq: params[:user_id] }),
            model_class: Loan,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Common::LoanPresenter
          }
        end

        def form_options_for_crowdfund
          {
            params: params,
            contract_class: Contracts::Algorithm::CrowdfundLoanContract,
            presenter_class: Presenters::Algorithm::CrowdfundedLoanPresenter
          }
        end
      end
    end
  end
end
