# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

module Operations
  module Transactions
    # Operation to Complete a Payment by its Transaction Code
    class CompletePaymentOperation < Trailblazer::Operation
      delegate :error!, to: Paw::Utils
      pass :contract_class!
      pass :build_model!
      pass :contract!
      pass :validate!
      pass :obtain_loan!
      pass :transaction!
      pass :close_unpaid_loan!
      pass :present!

      private

      def contract_class!(options, **)
        contract_class = options[:contract_class]
        unless contract_class.is_a?(Class) && contract_class.ancestors
                                                            .include?(
                                                              Reform::Form
                                                            )
          raise ArgumentError,
                'Supply a valid contract_class option'
        end
      end

      def build_model!(options, params:, **)
        options[:contract_data] = JSON.parse(params[:data].to_json, object_class: OpenStruct)
      end

      def contract!(options, **)
        options[:contract] ||= options[:contract_class].new(options[:contract_data])
      end

      def validate!(options, params:, **)
        valid = options[:contract].validate(params[:data])
        return if valid

        error!(
          errors: options[:contract].errors,
          status: options[:error_status]
        )
      end

      def obtain_loan!(options, contract:, **)
        loan = Queries::Mts::PendingPaymentQuery.new(Loan).call(contract.user_dui_number, contract.code)

        if loan.empty?
          error!(
            message: "Document number doesn't match transaction code.",
            status: 422
          )
        end

        options[:loan] = loan.first
      end

      def transaction!(options, loan:, contract:, **)
        ActiveRecord::Base.transaction do
          payment = create_payment(contract, loan)
          current_installment_amount = loan.current_installment_amount -
                                       (payment.principal_amount + payment.interest_amount)
          loan.update!(current_installment_amount: current_installment_amount,
                       current_overdue_fee: 0,
                       overdue_interest: 0)
          options[:payment] = payment
        end
      rescue ActiveRecord::RecordInvalid
        error!(
          message: 'Reference code already taken',
          status: 422
        )
      end

      def close_unpaid_loan!(_options, loan:, payment:, **)
        return unless loan.state_machine.in_state?(:unpaid)

        ActiveRecord::Base.transaction do
          process_payment(loan, payment)
        end
      end

      def present!(options, payment:, **)
        data = options[:presenter_class].new(payment)

        options[:response] = {
          data: data.to_hash
        }
      end

      def calculate_payment_interest(loan, installment_number)
        if loan.payments.in_state(:complete).where(installment_number: installment_number).empty?
          InterestCalculatorService.new.call(loan)
        else
          0
        end
      end

      def create_payment(contract, loan)
        installment_number = loan.total_installments - loan.pending_installments + 1
        payment_without_overdue_fee = contract.amount_paid.to_d - loan.current_overdue_fee.to_d
        interest_amount = calculate_payment_interest(loan, installment_number) + loan.overdue_interest
        principal_amount = payment_without_overdue_fee - interest_amount
        loan.payments.create!(interest_amount: interest_amount,
                              principal_amount: principal_amount,
                              code: contract.reference_code,
                              completed_at: Time.current,
                              installment_number: installment_number,
                              overdue_fee: loan.current_overdue_fee)
      end

      def process_payment(loan, payment)
        amortization = payment.principal_amount
        balance = loan.current_amount - amortization
        loan.current_amount = balance
        loan.current_overdue_fee = ENV['OVERDUE_FEE'].to_f if loan.current_installment_amount.positive?
        loan.save!
        loan.state_to(:paid) if loan.current_amount <= 0
      end
    end
  end
end
