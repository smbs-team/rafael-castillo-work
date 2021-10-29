# frozen_string_literal: true

module Api
  module V1
    module Mts
      # Withdrawals Controller
      class WithdrawalsController < Api::V1::Mts::ApplicationController
        before_action :inject_code_in_params, only: %i[show_withdrawal complete_withdrawal]
        before_action :inject_reference_code_in_params, only: %i[backroll]

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/mts/transactions/withdrawals/:code',
          method: 'post',
          summary: 'Shows withdrawal information',
          tags: [
            'api/v1/mts/transactions/withdrawals'
          ],
          success_status: 200,
          error_responses: [400, 401, 422, 500],
          contract: Contracts::Mts::CheckTransactionContract,
          presenter: Presenters::Mts::WithdrawalPresenter
        )

        def show_withdrawal
          response = Operations::ShowWithdrawalOperation.call(
            fetch_withdrawal_options.merge!(collection: false)
          )
          render json: response[:response], status: response[:status]
        end

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/mts/transactions/withdrawals/:code/complete',
          method: 'post',
          summary: 'Completes withdrawal',
          tags: [
            'api/v1/mts/transactions/withdrawals'
          ],
          success_status: 200,
          error_responses: [400, 401, 422, 500],
          presenter: Presenters::Mts::WithdrawalPresenter,
          contract: Contracts::Mts::CompleteWithdrawalContract
        )

        def complete_withdrawal
          response = Operations::Transactions::CompleteWithdrawalOperation.call(
            form_withdrawal_options
          )
          render json: response[:response], status: response[:status]
        end

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/mts/transactions/withdrawals/:code/backroll',
          method: 'post',
          summary: 'Backrolls withdrawal',
          tags: [
            'api/v1/mts/transactions/withdrawals'
          ],
          success_status: 200,
          error_responses: [400, 401, 422, 500],
          contract: Contracts::Mts::BackrollTransactionContract,
          presenter: Presenters::Mts::WithdrawalPresenter
        )

        def backroll
          response = Operations::Transactions::Backroller.call(
            form_backroll_options
          )
          render json: response[:response], status: response[:status]
        end

        private

        def fetch_withdrawal_options
          {
            params: params,
            model_class: Withdrawal,
            presenter_class: Presenters::Mts::WithdrawalPresenter,
            contract_class: Contracts::Mts::CheckTransactionContract,
            default_scope: lambda { |query|
              Queries::Mts::PendingWithdrawalQuery.new(query)
                                                  .call(data['user_dui_number'], data['code'])
            }
          }
        end

        def form_withdrawal_options
          {
            params: params,
            contract_class: Contracts::Mts::CompleteWithdrawalContract,
            presenter_class: Presenters::Mts::WithdrawalPresenter
          }
        end

        def form_backroll_options
          {
            params: params,
            contract_class: Contracts::Mts::BackrollTransactionContract,
            presenter_class: Presenters::Mts::WithdrawalPresenter
          }
        end

        def inject_code_in_params
          params[:data].merge!(code: params[:code])
        end

        def inject_reference_code_in_params
          params[:data].merge!(code: params[:reference_code])
        end
      end
    end
  end
end
