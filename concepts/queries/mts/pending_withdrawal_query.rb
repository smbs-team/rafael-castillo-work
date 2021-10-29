# frozen_string_literal: true

module Queries
  module Mts
    # Pull the current user's loan with crowdfunded status
    class PendingWithdrawalQuery < Paw::Queries::BaseQuery
      def call(dui_number, disbursement_code)
        result = Queries::Mts::WithdrawalWithDuiNumberQuery.new(relation).call(dui_number, disbursement_code)
        result.in_state(:ready)
      end
    end
  end
end
