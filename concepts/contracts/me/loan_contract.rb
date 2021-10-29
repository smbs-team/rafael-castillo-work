# frozen_string_literal:true

module Contracts
  module Me
    # Loan Contract/Form Object
    class LoanContract < Contracts::BaseContractPatched
      property :user_id, documentation: { skip: true }
      property :initial_amount
      property :current_interest_rate
      property :total_installments
      property :installment_amount
      property :subscription_fee
      property :disbursement_commision
      property :reason, virtual: true
      property :process_finish_at
      property :process_start_at
      validates :initial_amount, :current_interest_rate,
                :total_installments, :installment_amount,
                :subscription_fee, :disbursement_commision,
                :process_start_at, :process_finish_at,
                :reason, presence: true
    end
  end
end
