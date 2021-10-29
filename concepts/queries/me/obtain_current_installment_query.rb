# frozen_string_literal: true

module Queries
  module Me
    # Pull the current user's loan with crowdfunded status
    class ObtainCurrentInstallmentQuery < Paw::Queries::BaseQuery
      def call(current_user_id)
        result = Queries::Commons::CurrentUserQuery.new(relation).call(current_user_id)
        result.in_state(:active, :unpaid)
      end
    end
  end
end
