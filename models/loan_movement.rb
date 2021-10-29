# frozen_string_literal:true

# Loan Movement
class LoanMovement < ApplicationRecord
  has_many :loan_movement_transitions, autosave: false

  validates_uniqueness_of :code, scope: [:loan_id], if: -> { !code.blank? }

  belongs_to :loan
  enum kind: {
    withdrawal: 'withdrawal',
    payment: 'payment',
    nonpayment: 'nonpayment'
  }

  scope :withdrawals, -> { where(kind: 'withdrawal') }
  scope :payments, -> { where(kind: 'payment') }
  scope :nonpayments, -> { where(kind: 'nonpayment') }

  delegate :user_name, to: :loan
  delegate :user_dui_number, to: :loan
  delegate :user_nit_number, to: :loan
  delegate :user_age, to: :loan

  def state_machine
    state_machine_name = "#{kind.camelize}StateMachine".safe_constantize
    @state_machine ||= state_machine_name.new(self, transition_class: LoanMovementTransition)
  end

  def status
    state_machine.current_state
  end

  def amount
    interest_amount + principal_amount + overdue_fee
  end

  def state_to(state)
    state_machine.transition_to!(state)
  end
end
