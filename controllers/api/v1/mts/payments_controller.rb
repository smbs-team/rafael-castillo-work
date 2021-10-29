# frozen_string_literal: true

module Api
  module V1
    module Mts
      # Payments Controller
      class PaymentsController < Api::V1::Mts::ApplicationController
        before_action :inject_code_in_params, only: %i[show_payment complete_payment]

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/mts/transactions/payments/:code',
          method: 'post',
          summary: 'Shows payment information',
          tags: [
            'api/v1/mts/transactions/payments'
          ],
          success_status: 200,
          error_responses: [400, 401, 422, 500],
          contract: Contracts::Mts::CheckTransactionContract,
          presenter: Presenters::Mts::CheckPaymentPresenter
        )

        def show_payment
          response = Operations::SingleItemWithContractOperation.call(
            fetch_payment_options.merge!(collection: false)
          )
          render json: response[:response], status: response[:status]
        end

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/mts/transactions/payments/:code/complete',
          method: 'post',
          summary: 'Completes payment',
          tags: [
            'api/v1/mts/transactions/payments'
          ],
          success_status: 200,
          error_responses: [400, 401, 422, 500],
          presenter: Presenters::Mts::TransactionPresenter,
          contract: Contracts::Mts::CompletePaymentContract
        )

        def complete_payment
          response = Operations::Transactions::CompletePaymentOperation.call(
            form_payment_options
          )
          render json: response[:response], status: response[:status]
        end

        private

        def fetch_payment_options
          {
            params: params,
            model_class: Loan,
            contract_class: Contracts::Mts::CheckTransactionContract,
            presenter_class: Presenters::Mts::CheckPaymentPresenter,
            default_scope: lambda { |query|
              Queries::Mts::PendingPaymentQuery.new(query)
                                               .call(data['user_dui_number'], data['code'])
            }
          }
        end

        def form_payment_options
          {
            params: params,
            contract_class: Contracts::Mts::CompletePaymentContract,
            presenter_class: Presenters::Mts::TransactionPresenter
          }
        end

        def inject_code_in_params
          params[:data].merge!(code: params[:code])
        end
      end
    end
  end
end
