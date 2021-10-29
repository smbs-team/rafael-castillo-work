# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for LoanMovement model
    class LoanMovementPresenter < Paw::Presenters::Api::BasePresenter
      property :type, exec_context: :decorator
      property :amount
      property :installment_number, as: :installment, render_nil: false
      property :date, exec_context: :decorator
      property :code, render_nil: false
      property :disbursement_code, render_nil: false
      property :status, exec_context: :decorator

      def type
        I18n.t(represented.kind)
      end

      def date
        represented.created_at
      end

      def status
        I18n.t(represented.status)
      end
    end
  end
end
