# frozen_string_literal:true

# Loans
class Loan < ApplicationRecord
  has_paper_trail versions: {
    name: :loan_logs
  }

  belongs_to :user

  has_one :refilled_loan, class_name: 'Loan', foreign_key: 'parent_loan_id'
  belongs_to :parent_loan, class_name: 'Loan', optional: true

  has_many :son_loans, class_name: 'Loan', foreign_key: 'root_loan_id'
  belongs_to :root_loan, class_name: 'Loan', optional: true

  has_many :legal_documents, as: :documentable, dependent: :destroy
  has_many :loan_movements, dependent: :destroy
  has_many :loan_reasons, dependent: :destroy
  has_many :withdrawals
  has_many :payments
  has_many :nonpayments
  has_many :reasons, through: :loan_reasons

  validates :initial_amount, :current_interest_rate, numericality: true
  validates :payment_code, uniqueness: true, if: -> { !payment_code.blank? }

  delegate :first_name, :last_name, to: :user, prefix: true
  delegate :dui_number, to: :user, prefix: true
  delegate :nit_number, to: :user, prefix: true
  delegate :name, to: :user, prefix: true
  delegate :age, to: :user, prefix: true

  has_many :loan_transitions, autosave: false, dependent: :destroy

  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: LoanTransition,
    initial_state: LoanStateMachine.initial_state
  ]

  def state_machine
    @state_machine ||= LoanStateMachine.new(self, transition_class: LoanTransition)
  end

  def state_to(state)
    state_machine.transition_to!(state)
  end

  def status
    state_machine.current_state
  end
end
