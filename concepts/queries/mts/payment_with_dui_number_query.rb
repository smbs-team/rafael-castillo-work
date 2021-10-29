# frozen_string_literal: true

module Queries
  module Mts
    # Query to obtain a resource with a given disbursement or payment code
    class PaymentWithDuiNumberQuery < Paw::Queries::BaseQuery
      def call(number, code)
        query = relation.joins(user: :documents).where(
          condition,
          number,
          code
        )
        concat!(query)
      end

      def condition
        "documents.number = ? AND documents.kind = 'dui'
        AND #{relation.table_name}.payment_code = ?"
      end
    end
  end
end
