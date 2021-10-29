# frozen_string_literal: true

module Api
  module V1
    module Me
      # Loans Controller
      class LoansController < Api::V1::Me::ApplicationController # rubocop:disable Metrics/ClassLength
        skip_before_action :require_data!, only: %i[current_installment refill_availability withdrawal]

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/loans/current_installment',
          method: 'get',
          collection: false,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'Loan current installment',
          tags: [
            'api/v1/me/loans'
          ],
          success_status: 200,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::InstallmentPresenter
        )

        def current_installment
          response = Operations::PresentSingleItemFromQueryOperation.call(
            installment_fetch_options.merge!(collection: false)
          )
          render json: response[:response], status: response[:status]
        end

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/loans',
          method: 'post',
          summary: 'Create a loan',
          tags: [
            'api/v1/me/loans'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Common::LoanPresenter,
          contract: Contracts::Me::LoanContract
        )

        def create
          response = Operations::CreateLoanOperation.call(
            form_options
          )
          render json: response[:response], status: 201
        end

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/loans/refill',
          method: 'post',
          summary: 'Create a refill for a loan',
          tags: [
            'api/v1/me/loans'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Common::LoanPresenter,
          contract: Contracts::Me::LoanContract
        )

        def refill
          response = Operations::CreateRefillOperation.call(
            refill_options
          )
          render json: response[:response], status: 201
        end

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/loans/application',
          method: 'post',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'Request loan to fiados api',
          tags: [
            'api/v1/me/loans'
          ],
          success_status: 200,
          error_responses: [401, 422, 500, 404],
          contract: Contracts::Me::RequestLoanContract,
          presenter: Presenters::Me::RequestLoanPresenter
        )

        def application
          response = Operations::RequestLoanOperation.call(
            loan_options
          )
          render json: response[:response], status: response[:status]
        end

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/loans/refill_application',
          method: 'post',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'Request refill to fiados api',
          tags: [
            'api/v1/me/loans'
          ],
          success_status: 200,
          error_responses: [401, 422, 500, 404],
          contract: Contracts::Me::RequestLoanContract,
          presenter: Presenters::Me::RequestLoanPresenter
        )

        def refill_application
          response = Operations::RequestRefillOperation.call(
            loan_options
          )
          render json: response[:response], status: response[:status]
        end

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/loans/withdrawal',
          method: 'get',
          collection: false,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'Shows loan withdrawal data',
          tags: [
            'api/v1/me/loans'
          ],
          success_status: 200,
          error_responses: [401, 422, 500],
          presenter: Presenters::Common::LoanMovementPresenter
        )

        def withdrawal
          response = Operations::PresentSingleItemFromQueryOperation.call(
            withdrawal_options.merge!(collection: false)
          )
          render json: response[:response], status: response[:status]
        end

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/loans/refill_availability',
          method: 'get',
          collection: false,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'Check if a loan meets the requirements to be refilled',
          tags: [
            'api/v1/me/loans'
          ],
          success_status: 200,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::InstallmentPresenter
        )

        def refill_availability
          response = Operations::RefillAvailabilityOperation.call(
            refill_availability_options
          )
          render json: response[:response], status: response[:status]
        end

        private

        def withdrawal_options
          {
            params: params,
            model_class: Withdrawal,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Common::LoanMovementPresenter,
            default_scope: lambda { |query|
              Queries::Me::ObtainCurrentWithdrawalQuery.new(query).call(current_user.id)
            }
          }
        end

        def installment_fetch_options
          {
            params: params,
            model_class: Loan,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Me::InstallmentPresenter,
            default_scope: lambda { |query|
              Queries::Me::ObtainCurrentInstallmentQuery.new(query).call(current_user.id)
            }
          }
        end

        def fetch_options
          {
            params: params,
            model_class: Loan,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Common::LoanPresenter,
            default_scope: lambda { |query|
              Queries::Commons::CurrentUserQuery.new(query).call(current_user.id)
            }
          }
        end

        def form_options
          {
            params: params,
            model_class: Loan,
            current_user: current_user,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::LoanContract,
            presenter_class: Presenters::Common::LoanPresenter
          }
        end

        def refill_options
          {
            params: params.merge!(action: 'create'),
            model_class: Loan,
            current_user: current_user,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::LoanContract,
            presenter_class: Presenters::Common::LoanPresenter
          }
        end

        def loan_options
          {
            params: params,
            current_user: current_user,
            contract_class: Contracts::Me::RequestLoanContract,
            presenter_class: Presenters::Me::RequestLoanPresenter
          }
        end

        def refill_availability_options
          {
            params: params,
            current_user: current_user,
            model_class: Loan,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Common::LoanPresenter
          }
        end
      end
    end
  end
end
