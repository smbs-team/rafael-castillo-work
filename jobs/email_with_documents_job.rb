# frozen_string_literal: true

require 'bureau_generator'
require 'pdf_generator'

# Generate Mutuos
class EmailWithDocumentsJob < ApplicationJob
  queue_as :default

  def perform(loan_id)
    user = Loan.find(loan_id).user
    legal_documents = LegalDocument.where(documentable_id: loan_id, documentable_type: 'Loan')
                                   .or(LegalDocument.where(documentable_id: user.id, documentable_type: 'User'))

    if legal_documents.all?(&:signed?)
      UserMailer.legal_documents_email(loan_id).deliver_later
    else
      Rails.logger.warn "Documents are not ready, requeuing 'Documents mail' for loan with id: #{loan_id}"
      self.class.perform_later(loan_id)
    end
  end
end
