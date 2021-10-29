# frozen_string_literal: true

require 'signature_generator'
require 'pdf_manager'

# Sign Documents
class SignDocumentsJob < ApplicationJob
  queue_as :default

  def perform(legal_documents, signature_key)
    signature_image = obtain_image(signature_key)
    ActiveRecord::Base.transaction do
      legal_documents.each do |document_id|
        sign_document(document_id, signature_image)
      end
    end
  rescue StandardError
    message = 'Signing of documents has failed'
    Rails.logger.warn message
    message
  ensure
    @s3.delete_objects(bucket: ENV['AWS_BUCKET'], delete: { objects: [{ key: signature_key }] })
  end

  private

  def obtain_image(key)
    @s3 = Aws::S3::Client.new
    @s3.get_object(bucket: ENV['AWS_BUCKET'], key: key).body
  end

  def sign_document(document_id, signature_image)
    document = LegalDocument.find document_id
    document_kind = document.kind
    signature = SignatureGenerator.new(
      signature_image,
      "#{document_kind.camelize}Generator".constantize::SIGNATURE_COORDINATES,
      'string'
    )
    manager = PdfManager.new(document, signature)
    result = manager.sign_pdf
    manager.attach_pdf(result, document.name)
    document.update!(signed: true)
  end
end
