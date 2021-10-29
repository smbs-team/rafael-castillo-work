# frozen_string_literal: true

module Operations
  # Creates a Loan for the current user
  class CreateLoanOperation < Paw::Operations::Api::Form
    pass :inject_user_id!, after: :validate!
    pass :fetch_active_loan!, after: :inject_user_id!
    pass :set_due_date!, after: :fetch_active_loan!
    pass :set_current_installment_amount!, after: :set_due_date!
    pass :set_pending_installments!, after: :set_current_installment_amount!
    pass :set_withdrawal_amount!, after: :set_pending_installments!
    pass :set_extra_payments_to_amount!, after: :set_withdrawal_amount!
    pass :set_current_amount!, after: :set_extra_payments_to_amount!
    pass :match_loan_data!, after: :set_current_amount!
    pass :send_request_to_fiado!, after: :match_loan_data!
    pass :create_withdrawal!, after: :persist!
    FORMULA_CONSTANT = 1.0

    private

    def inject_user_id!(options, current_user:, **)
      options[:contract].user_id = current_user.id
    end

    def fetch_active_loan!(_options, current_user:, **)
      return if current_user.loans.not_in_state(:paid, :canceled).empty? || current_user.loans.empty?

      error!(
        errors: { loan: I18n.t('activerecord.errors.models.loan.validations.loans.active') },
        status: 422
      )
    end

    def set_due_date!(_options, model:, **)
      model.current_installment_due_at = Date.current.in_time_zone + 1.month
    end

    def set_current_installment_amount!(_options, model:, contract:, **)
      model.current_installment_amount = contract.installment_amount
    end

    def set_pending_installments!(_options, model:, contract:, **)
      model.pending_installments = contract.total_installments
    end

    def set_withdrawal_amount!(options, contract:, **)
      options[:withdrawal_amount] = contract.initial_amount
    end

    def set_extra_payments_to_amount!(_options, contract:, **)
      contract.initial_amount = contract.initial_amount.to_d +
                                contract.subscription_fee.to_d +
                                contract.disbursement_commision.to_d
    end

    def set_current_amount!(_options, model:, contract:, **)
      model.current_amount = contract.initial_amount
    end

    def match_loan_data!(_options, params:, contract:, **)
      expected_installment = calculate_expected_installment(contract)
      return if expected_installment.to_s == params[:data][:installment_amount].to_s

      error!(
        errors: { loan: I18n.t('activerecord.errors.models.loan.validations.loans.installment_mismatch') },
        status: 422
      )
    end

    def send_request_to_fiado!(_options, contract:, **)
      body_params = {
        user_id: contract.user_id,
        initial_amount: contract.initial_amount,
        total_installments: contract.total_installments,
        interest_rate: contract.current_interest_rate,
        installment_amount: contract.installment_amount,
        reason: contract.reason
      }
      LoanCreationJob.perform_later(body_params)
      nil
    end

    def create_withdrawal!(_options, model:, withdrawal_amount:, **)
      model.withdrawals.create!(principal_amount: withdrawal_amount,
                                interest_amount: 0.0)
    end

    def calculate_expected_installment(contract)
      monthly_interest_rate = contract.current_interest_rate.to_d / 100
      installments = contract.total_installments.to_d
      interest, other_interest = calculate_installment_interests(monthly_interest_rate, installments)
      total_loan_amount = contract.initial_amount.to_d
      (total_loan_amount * (interest / other_interest)).round(2, :down)
    end

    def calculate_installment_interests(monthly_interest_rate, installments)
      interest = ((FORMULA_CONSTANT + monthly_interest_rate)**installments) * monthly_interest_rate
      other_interest = ((FORMULA_CONSTANT + monthly_interest_rate)**installments) - FORMULA_CONSTANT
      [interest, other_interest]
    end
  end
end
