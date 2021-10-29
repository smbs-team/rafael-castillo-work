# frozen_string_literal: true

require 'bureau_generator'
require 'pdf_generator'

# Generate Mutuos
class GenerateAndSignBureauJob < ApplicationJob
  queue_as :default

  def perform(document_id, signature_key, user_id)
    signature_image = obtain_image(signature_key)
    ActiveRecord::Base.transaction do
      legal_document = LegalDocument.find document_id
      user = User.find user_id
      bureau = BureauGenerator.new(user, signature_image)
      pdf_manager = PdfManager.new(legal_document, bureau)
      pdf_manager.attach_pdf
      legal_document.update!(signed: true)
    end
  rescue StandardError
    message = 'Bureau Generation has failed'
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
end
