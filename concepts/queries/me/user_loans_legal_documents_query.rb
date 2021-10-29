# frozen_string_literal: true

module Queries
  module Me
    # Pull the current user's loan with crowdfunded status
    class UserLoansLegalDocumentsQuery < Paw::Queries::BaseQuery
      def call(current_user_id)
        query = relation
                .joins(loan: %i[user])
                .where('users.id = ?', current_user_id)
        concat!(query)
      end
    end
  end
end
