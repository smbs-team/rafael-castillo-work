# frozen_string_literal: true

# Withdrawal model
class Withdrawal < LoanMovement
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: LoanMovementTransition,
    initial_state: WithdrawalStateMachine.initial_state
  ]

  default_scope { where(kind: 'withdrawal') }

  def state_machine
    @state_machine ||= WithdrawalStateMachine.new(self, transition_class: LoanMovementTransition)
  end

  def status
    state_machine.current_state
  end
end
