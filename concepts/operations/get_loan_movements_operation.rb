# frozen_string_literal: true

module Operations
  # Operation to get all loan movements from current active loan
  class GetLoanMovementsOperation < Trailblazer::Operation
    delegate :error!, to: Paw::Utils
    pass :get_current_loan!
    pass :get_movements!
    pass :obtain_period_due_date!
    pass :group_movements!
    pass :present!

    private

    def get_current_loan!(options, current_user:, **)
      loan = current_user.loans.not_in_state(:refilled).not_in_state(:paid).not_in_state(:canceled).first

      unless loan
        error!(
          errors: { loan: "User doesn't have an active loan" },
          status: '404'
        )
      end

      options[:loan] = loan
    end

    def get_movements!(options, loan:, **)
      loan_id = loan.root_loan_id.nil? ? loan.id : loan.root_loan_id
      options[:movements] = LoanMovement.joins(:loan)
                                        .where('loans.root_loan_id = ? OR loans.id = ?', loan_id, loan_id)
                                        .order('created_at DESC')
    end

    def obtain_period_due_date!(options, movements:, **)
      periods = movements.group_by(&:installment_number)
      options[:due_date_result] = periods.map { |pe, v| v.any?(&:nonpayment?) unless pe.nil? }.compact
    end

    def group_movements!(options, movements:, due_date_result:, **)
      result = group_with(movements, :year)
      result = result.map do |year, array|
        OpenStruct.new('year' => year,
                       'months' => group_with(array, '%B').map do |month, data|
                                     OpenStruct.new('month' => I18n.t(month),
                                                    'transactions' => data,
                                                    'past_due' => due_date_result.shift)
                                   end)
      end
      options[:movements] = OpenStruct.new('years' => result)
    end

    def present!(options, movements:, **)
      data = options[:presenter_class].new(movements)

      options[:response] = {
        data: data.to_hash
      }
    end

    def group_with(data, symbol)
      data.group_by do |movement|
        case symbol
        when Symbol
          movement.created_at.send(symbol)
        when String
          movement.created_at.strftime(symbol)
        end
      end
    end
  end
end
