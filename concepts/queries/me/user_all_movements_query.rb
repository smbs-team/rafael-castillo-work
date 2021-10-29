# frozen_string_literal: true

module Queries
  module Me
    # Pull the active withdrawal from loan
    class UserAllMovementsQuery < Paw::Queries::BaseQuery
      def call(user_id)
        query = relation.joins(:loan).where(
          condition,
          user_id
        )
        concat!(query)
      end

      def condition
        'loans.user_id = ?'
      end
    end
  end
end
