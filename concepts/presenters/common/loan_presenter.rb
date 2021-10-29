# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for Loan model
    class LoanPresenter < Paw::Presenters::Api::BasePresenter
      property :current_amount, exec_context: :decorator
      property :initial_amount, exec_context: :decorator
      property :current_installment_amount, exec_context: :decorator
      property :installment_amount
      property :current_installment_due_at
      property :total_installments
      property :pending_installments
      property :current_interest_rate
      property :created_at
      property :start_date
      property :process_start_at
      property :process_finish_at
      property :payment_code
      property :current_overdue_fee
      property :status, exec_context: :decorator
      property :reason, exec_context: :decorator

      def status
        represented.status
      end

      def current_amount
        if represented.current_installment_amount.negative?
          0
        else
          represented.current_amount&.round(2)
        end
      end

      def initial_amount
        represented.initial_amount&.round(2)
      end

      def current_installment_amount
        if represented.current_installment_amount.negative?
          0
        else
          represented.current_installment_amount&.round(2)
        end
      end

      def reason
        represented.reasons.first&.label
      end
    end
  end
end
