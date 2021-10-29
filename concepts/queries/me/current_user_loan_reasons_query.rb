# frozen_string_literal: true

module Queries
  module Me
    # Always pull the resources that the current user owns
    class CurrentUserLoanReasonsQuery < Paw::Queries::BaseQuery
      def call(current_user)
        query = relation.joins(loan_reasons: [loan: %i[user loan_transitions]]).where(
          condition,
          current_user,
          'active'
        )
        concat!(query)
      end

      def condition
        "users.id = ? AND
        loan_transitions.to_state = ? AND
        loan_transitions.most_recent = true"
      end
    end
  end
end
