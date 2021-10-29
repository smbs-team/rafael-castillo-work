# frozen_string_literal: true

# Cancel Loan
class CancelLoanJob < ApplicationJob
  queue_as :default

  def perform(id, movement_status)
    ActiveRecord::Base.transaction do
      loan = Loan.find(id)
      loan.withdrawals.first.state_to(movement_status)
      remove_documents(loan)
      send_email(id, movement_status, loan)
    end
  rescue Statesman::TransitionFailedError
    Rails.logger.warn 'Loan Collected' if movement_status == 'uncollected'
    Rails.logger.warn 'Loan Signed' if movement_status == 'expired'
  rescue StandardError
    Rails.logger.warn 'Loan Cancellation Failed'
  end

  private

  def remove_documents(loan)
    loan.legal_documents.each do |legal_document|
      legal_document.document.purge_later
    end
  end

  def send_email(id, movement_status, loan)
    UserMailer.cancel_loan_email(id, movement_status).deliver_later if loan.user.email
  end
end
