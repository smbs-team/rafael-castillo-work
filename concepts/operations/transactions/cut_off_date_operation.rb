# frozen_string_literal: true

module Operations
  module Transactions
    # Operation to apply calculations to loan each cut off date
    class CutOffDateOperation < Trailblazer::Operation
      delegate :error!, to: Paw::Utils
      pass :reduce_balance!
      pass :assign_overdue_fee!
      pass :assign_overdue_interest!
      pass :create_nonpayment_debt!
      pass :reduce_installments!
      pass :update_state!
      pass :calculate_next_installment!
      pass :new_due_date!
      pass :persist!

      private

      def reduce_balance!(_options, loan:, **)
        amortization = obtain_amortization(loan)
        balance = loan.current_amount - amortization
        loan.current_amount = balance
      end

      def assign_overdue_fee!(_options, loan:, **)
        loan.current_overdue_fee = ENV['OVERDUE_FEE'] if loan.current_installment_amount.positive?
      end

      def create_nonpayment_debt!(_options, loan:, **)
        return unless loan.current_installment_amount.positive?

        installment_number = find_installment_number(loan)
        loan.nonpayments.create!(principal_amount: loan.current_installment_amount,
                                 interest_amount: 0.0,
                                 installment_number: installment_number + 1,
                                 created_at: get_nonpayment_date(loan, installment_number))
      end

      def find_installment_number(loan)
        loan.total_installments - loan.pending_installments + 1
      end

      def assign_overdue_interest!(_options, loan:, **)
        if loan.payments.in_state(:complete).where(installment_number: find_installment_number(loan)).empty?
          loan.overdue_interest = loan.overdue_interest + InterestCalculatorService.new.call(loan)
        else
          0
        end
      end

      def reduce_installments!(_options, loan:, **)
        loan.pending_installments = loan.pending_installments - 1
      end

      def calculate_next_installment!(_options, loan:, **)
        return if loan.state_machine.in_state?(:paid, :unpaid)

        interest_to_paid = InterestCalculatorService.new.call(loan)
        next_month_amortization = loan.installment_amount - interest_to_paid
        next_balance = loan.current_amount - next_month_amortization
        loan.current_installment_amount = assign_next_installment(loan, next_balance, interest_to_paid)
      end

      def new_due_date!(_options, loan:, **)
        return if loan.state_machine.in_state?(:paid, :unpaid)

        loan.current_installment_due_at = loan.current_installment_due_at + 1.month
      end

      def persist!(_options, loan:, **)
        loan.save!
      end

      def update_state!(_options, loan:, **)
        return if loan.state_machine.in_state?(:paid, :unpaid)

        if loan.current_amount <= 0
          loan.state_to(:paid)
        elsif loan.pending_installments.zero?
          loan.state_to(:unpaid)
        end
      end

      def obtain_amortization(loan)
        installment_number = loan.total_installments - loan.pending_installments + 1
        payments = loan.payments.in_state(:complete).where(installment_number: installment_number)
        payments.inject(0) { |sum, payment| sum + payment.principal_amount }
      end

      def assign_next_installment(loan, next_balance, interest_to_paid)
        if next_balance >= 0
          if loan.pending_installments == 1 && next_balance.positive?
            # User has pending payments, last installment will increase
            loan.current_amount + interest_to_paid
          else
            # Happy path, payment from month to month
            loan.installment_amount
          end
        else
          # User has made payments in advance, last installment will be reduce
          loan.pending_installments = 1
          loan.current_amount + interest_to_paid
        end
      end

      def get_nonpayment_date(loan, installment_number)
        return loan.start_date.next_month(installment_number).next_day if installment_number.positive?

        loan.start_date.next_month(installment_number)
      end
    end
  end
end
