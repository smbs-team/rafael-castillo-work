# frozen_string_literal: true

# Handles withdrawals' states
class WithdrawalStateMachine
  include Statesman::Machine

  # States
  state :in_progress, initial: true
  state :expired
  state :ready
  state :uncollected
  state :complete
  state :backrolled

  # Allowed transitions
  transition from: :in_progress,  to: %i[ready expired]
  transition from: :ready,        to: %i[complete uncollected]
  transition from: :complete,     to: %i[backrolled]

  # Guards
  guard_transition(to: :expired) do |withdrawal|
    withdrawal.loan.status == 'crowdfunded'
  end

  guard_transition(to: :uncollected) do |withdrawal|
    withdrawal.loan.status == 'disbursed'
  end

  # Callbacks
  after_transition(from: :in_progress, to: :expired) do |withdrawal, _transition|
    withdrawal.loan.state_to(:canceled)
  end

  after_transition(from: :in_progress, to: :ready) do |withdrawal, _transition|
    withdrawal.loan.state_to(:disbursed)
    # user = withdrawal.loan.user
    # if user.legal_documents.where(kind: 'access_contract').empty?
    #   GenerateAccessContractJob.perform_later(user.id, document.id)
    # end
  end

  after_transition(from: :ready, to: :complete) do |withdrawal, _transition|
    withdrawal.loan.state_to(:active)
    EmailWithDocumentsJob.perform_later(withdrawal.loan.id)
  end

  after_transition(from: :ready, to: :uncollected) do |withdrawal, _transition|
    withdrawal.loan.state_to(:canceled)
  end
end
