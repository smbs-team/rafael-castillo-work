# frozen_string_literal: true

# Handles payments' states
class NonpaymentStateMachine
  include Statesman::Machine

  # States
  state :debt, initial: true

  # Allowed Transitions

  # Callbacks
end
