# frozen_string_literal: true

# Legal Documents
class LegalDocument < ApplicationRecord
  has_one_attached :document

  belongs_to :documentable, polymorphic: true

  belongs_to :loan, -> { where(legal_documents: { documentable_type: 'Loan' }) },
             foreign_key: 'documentable_id', optional: true

  belongs_to :user, -> { where(legal_documents: { documentable_type: 'User' }) },
             foreign_key: 'documentable_id', optional: true

  enum kind: {
    natural_mutuo: 'natural_mutuo',
    juridical_mutuo: 'juridical_mutuo',
    cooperative_mutuo: 'cooperative_mutuo',
    bureau: 'bureau',
    oid: 'oid',
    access_contract: 'access_contract'
  }

  validates :kind, presence: true

  def document_url
    if %i[test local].include?(Rails.application.config.active_storage.service)
      Rails.application.routes.url_helpers.rails_blob_url(document)
    else
      document.service_url
    end
  end
end
