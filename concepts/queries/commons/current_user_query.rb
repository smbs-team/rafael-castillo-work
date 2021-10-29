# frozen_string_literal: true

module Queries
  module Commons
    # Always pull the resources that the current user owns
    class CurrentUserQuery < Paw::Queries::BaseQuery
      def call(value)
        query = relation.where(condition, parse_value(value))
        concat!(query)
      end

      def condition
        "(#{relation.table_name}.user_id) = ?"
      end

      def parse_value(value)
        value
      end
    end
  end
end
