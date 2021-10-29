# frozen_string_literal: true

# Loan Movement Transition
class LoanMovementTransition < ApplicationRecord
  include Statesman::Adapters::ActiveRecordTransition
  validates :to_state, inclusion: { in: WithdrawalStateMachine.states + PaymentStateMachine.states }

  belongs_to :loan_movement, inverse_of: :loan_movement_transitions
end
