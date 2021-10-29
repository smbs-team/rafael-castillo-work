# frozen_string_literal: true

require 'access_contract_generator'
require 'pdf_generator'

# Generate Mutuos
class GenerateAccessContractJob < ApplicationJob
  queue_as :default

  def perform(user_id) # rubocop:disable Metrics/MethodLength
    user = User.find user_id
    return if user.access_contract_generated?

    ActiveRecord::Base.transaction do
      contract = AccessContractGenerator.new(user)

      legal_document = user
                       .legal_documents
                       .create!(
                         kind: 'access_contract',
                         name: "Contrato de acceso a la plataforma de #{user.name}",
                         producer_name: contract.producer_name
                       )
      pdf_manager = PdfManager.new(legal_document, contract)
      pdf_manager.attach_pdf
      # legal_document.update!(signed: true)
    end
  rescue StandardError
    message = 'Access Plataform Contract Generation has failed'
    Rails.logger.warn message
    message
  end
end
