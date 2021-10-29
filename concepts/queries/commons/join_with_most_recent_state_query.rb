# frozen_string_literal: true

module Queries
  module Commons
    # Query to join and obtain a resource with other that has a state machine in a particular state
    class JoinWithWithMostRecentStateQuery < Paw::Queries::BaseQuery
      def call(model_class, state)
        reference = reference_name(model_class)

        query = relation
                .joins(reference => "#{reference}_transitions")
                .where(condition(reference), state)
        concat!(query)
      end

      def condition(reference)
        "#{reference}_transitions.to_state = ? AND #{reference}_transitions.most_recent = true"
      end

      def reference_name(model_class)
        model_class.table_name.singularize
      end
    end
  end
end
