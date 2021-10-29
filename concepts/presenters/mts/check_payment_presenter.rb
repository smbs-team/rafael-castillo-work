# frozen_string_literal: true

module Presenters
  module Mts
    # Serializer/presenter for CheckPayment
    class CheckPaymentPresenter < Paw::Presenters::Api::BasePresenter
      property :payment_code, as: :code, render_nil: false
      property :user_name
      property :user_dui_number
      property :current_installment_amount, as: :amount, exec_context: :decorator
      property :transaction_status, as: :status, exec_context: :decorator

      def transaction_status
        I18n.t(represented.status)
      end

      def current_installment_amount
        if represented.current_installment_amount.negative?
          0
        else
          represented.current_installment_amount.round(2).to_f + represented.current_overdue_fee
        end
      end
    end
  end
end
