# frozen_string_literal: true

module Queries
  module Me
    # Pull the current user's loan with crowdfunded status
    class ObtainLoanLegalDocumentsQuery < Paw::Queries::BaseQuery
      def call(current_user_id)
        result = Queries::Me::UserLoansLegalDocumentsQuery.new(relation).call(current_user_id)
        Queries::Commons::JoinWithWithMostRecentStateQuery.new(result).call(Loan, 'crowdfunded')
      end
    end
  end
end
