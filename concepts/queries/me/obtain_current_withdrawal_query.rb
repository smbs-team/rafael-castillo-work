# frozen_string_literal: true

module Queries
  module Me
    # Pull the current user's loan with crowdfunded status
    class ObtainCurrentWithdrawalQuery < Paw::Queries::BaseQuery
      def call(current_user_id)
        result = Queries::Me::UserAllMovementsQuery.new(relation).call(current_user_id)
        result = result.in_state(:ready)
        Queries::Commons::JoinWithWithMostRecentStateQuery.new(result).call(Loan, 'disbursed')
      end
    end
  end
end
