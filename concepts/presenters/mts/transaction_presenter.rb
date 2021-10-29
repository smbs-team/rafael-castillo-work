# frozen_string_literal: true

module Presenters
  module Mts
    # Serializer/presenter for Transaction
    class TransactionPresenter < Paw::Presenters::Api::BasePresenter
      property :user_name
      property :user_dui_number
      property :code, as: :reference_code, render_nil: false
      property :amount
      property :transaction_status, as: :status, exec_context: :decorator

      def transaction_status
        I18n.t(represented.status)
      end
    end
  end
end
