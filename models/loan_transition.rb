# frozen_string_literal: true

# handles Loan transitions
class LoanTransition < ApplicationRecord
  include Statesman::Adapters::ActiveRecordTransition
  validates :to_state, inclusion: { in: LoanStateMachine.states }

  belongs_to :loan, inverse_of: :loan_transitions
end
