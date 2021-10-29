# frozen_string_literal:true

# Stores Gov't issued ID data and image
class Document < ApplicationRecord
  belongs_to :user
  has_many_attached :document_images

  validates_uniqueness_of :number, :kind, scope: [:user_id]

  validates_uniqueness_of :number

  enum kind: {
    dui: 'dui',
    nit: 'nit'
  }

  def document_images_urls
    if %i[test local].include?(Rails.application.config.active_storage.service)
      document_images&.map { |document_image| Rails.application.routes.url_helpers.rails_blob_url(document_image) }
    else
      document_images&.map { |document_image| document_image.service_url }
    end
  end
end
