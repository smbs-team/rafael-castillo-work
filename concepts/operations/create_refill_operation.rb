# frozen_string_literal: true

module Operations
  # Operation that creates a refill
  class CreateRefillOperation < Operations::CreateLoanOperation
    pass :fetch_active_loan!, override: true
    pass :set_parent_loan_id!, after: :match_loan_data!
    pass :set_root_loan_id!, after: :set_parent_loan_id!
    pass :transition_active_loan_to_frozen!, after: :send_request_to_fiado!

    private

    def fetch_active_loan!(options, current_user:, **)
      options[:active_loan] = current_user.loans.in_state(:active).first

      return if options[:active_loan]

      error!(
        errors: { loan: 'no active loan found' },
        status: 422
      )
    end

    def set_parent_loan_id!(options, model:, **)
      model.parent_loan_id = options[:active_loan].id
    end

    def set_root_loan_id!(options, model:, **)
      model.root_loan_id = if options[:active_loan].root_loan_id.present?
                             options[:active_loan].root_loan_id
                           else
                             options[:active_loan].id
                           end
    end

    def transition_active_loan_to_frozen!(options, **)
      options[:active_loan].state_machine.transition_to!(:frozen)
    end
  end
end
