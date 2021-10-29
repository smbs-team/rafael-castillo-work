# frozen_string_literal: true

module Operations
  module Algorithm
    # Operation to get all loan movements
    class GetLoanMovementsOperation < Operations::GetLoanMovementsOperation
      pass :get_current_loan!, override: true

      private

      def get_current_loan!(options, params:, **)
        loan = Loan.where(user_id: params[:user_id], id: params[:loan_id]).first

        unless loan
          error!(
            errors: { loan: 'loan not found' },
            status: '404'
          )
        end

        options[:loan] = loan
      end
    end
  end
end
