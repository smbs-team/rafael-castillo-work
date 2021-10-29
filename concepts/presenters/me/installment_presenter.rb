# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for Current Loan Installment
    class InstallmentPresenter < Paw::Presenters::Api::BasePresenter
      property :amount, exec_context: :decorator
      property :current_installment_due_at, as: :due_at
      property :pending_installments
      property :total_installments
      property :payment_code

      def amount
        if represented.current_installment_amount.negative?
          0
        else
          represented.current_installment_amount.round(2).to_f +
            represented.current_overdue_fee +
            represented.overdue_interest
        end
      end
    end
  end
end
