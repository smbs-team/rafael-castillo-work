# frozen_string_literal: true

# Handles payments' states
class PaymentStateMachine
  include Statesman::Machine

  # States
  state :complete, initial: true
  state :backrolled

  # Allowed Transitions
  transition from: :complete, to: %i[backrolled]

  # Callbacks
  after_transition(from: :complete, to: :backrolled) do |payment, transition|
    # TODO: Rollback all transaction that changed the amounts in loans
  end
end
