# frozen_string_literal: true

module Queries
  module Mts
    # Pull the current user's loan with active status
    class PendingPaymentQuery < Paw::Queries::BaseQuery
      def call(dui_number, payment_code)
        result = Queries::Mts::PaymentWithDuiNumberQuery.new(relation).call(dui_number, payment_code)
        result.in_state(:active, :unpaid)
      end
    end
  end
end
