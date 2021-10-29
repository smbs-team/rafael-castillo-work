# frozen_string_literal: true

# Payment model
class Payment < LoanMovement
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: LoanMovementTransition,
    initial_state: PaymentStateMachine.initial_state
  ]

  default_scope { where(kind: 'payment') }
  scope :from_month, ->(date) { where(completed_at: (date - 1.month)..(date + 1.day)) }

  def state_machine
    @state_machine ||= PaymentStateMachine.new(self, transition_class: LoanMovementTransition)
  end

  def status
    state_machine.current_state
  end
end
