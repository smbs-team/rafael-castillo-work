# frozen_string_literal: true

module Queries
  module Mts
    # Query to obtain a resource with a given disbursement or payment code
    class WithdrawalWithDuiNumberQuery < Paw::Queries::BaseQuery
      def call(number, code)
        query = relation.joins(loan: [user: :documents]).where(
          condition,
          number,
          code
        )
        concat!(query)
      end

      def condition
        "documents.number = ? AND documents.kind = 'dui'
        AND loan_movements.kind = 'withdrawal'
        AND loan_movements.disbursement_code = ?"
      end
    end
  end
end
