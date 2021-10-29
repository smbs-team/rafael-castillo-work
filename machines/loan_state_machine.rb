# frozen_string_literal: true

# Handles loan's states
class LoanStateMachine
  include Statesman::Machine

  # States
  state :confirmed, initial: true
  state :crowdfunded
  state :canceled
  state :disbursed
  state :active
  state :frozen
  state :refilled
  state :paid
  state :unpaid

  # Allowed transitions
  transition from: :confirmed, to: :crowdfunded
  transition from: :crowdfunded, to: %i[canceled disbursed]
  transition from: :disbursed, to: %i[active canceled]
  transition from: :active, to: %i[refilled paid disbursed frozen unpaid]
  transition from: :unpaid, to: :paid
  transition from: :frozen, to: :refilled

  # Guards
  guard_transition(to: :unpaid) do |loan|
    loan.pending_installments = 0
  end

  guard_transition(to: :paid) do |loan|
    loan.current_amount = 0
  end

  # Callbacks
  after_transition(from: :confirmed, to: :crowdfunded) do |loan|
    MutuosAreReadyJob.perform_later(loan.id)
    CancelLoanJob.set(wait: 72.hours).perform_later(loan.id, 'expired')
  end

  after_transition(from: :crowdfunded, to: :disbursed) do |loan|
    loan.update!(payment_code: CodeGeneratorService.call)
    DisbursementAboutToExpireReminderJob.set(wait: 42.hours).perform_later(loan.id)
    CancelLoanJob.set(wait: 48.hours).perform_later(loan.id, 'uncollected')
  end

  after_transition(from: :disbursed, to: :active) do |loan|
    loan.update!(start_date: Time.current)
  end

  before_transition(from: :disbursed, to: :active) do |loan|
    loan.parent_loan.state_to(:refilled) if loan.parent_loan.present?
  end
end
