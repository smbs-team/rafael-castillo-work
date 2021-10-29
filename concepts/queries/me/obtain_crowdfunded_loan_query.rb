# frozen_string_literal: true

module Queries
  module Me
    # Pull the current user's loan with crowdfunded status
    class ObtainCrowdfundedLoanQuery < Paw::Queries::BaseQuery
      def call(current_user_id)
        result = Queries::Commons::CurrentUserQuery.new(relation).call(current_user_id)
        result.in_state(:crowdfunded).first
      end
    end
  end
end
