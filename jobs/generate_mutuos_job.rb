# frozen_string_literal: true

require 'natural_mutuo_generator'
require 'juridical_mutuo_generator'
require 'cooperative_mutuo_generator'
require 'oid_generator'
require 'pdf_generator'

# Generate Mutuos
class GenerateMutuosJob < ApplicationJob
  queue_as :default

  def perform(producers, loan_id)
    loan = Loan.includes(:reasons, user: %i[addresses documents]).find(loan_id)
    ActiveRecord::Base.transaction do
      producers.each { |producer| create_mutuo(producer, loan) }
      create_oid_doc(loan) if loan.user.enterprise?
      loan.state_to(:crowdfunded)
    end
  rescue StandardError
    message = 'Mutuo Generation has failed'
    Rails.logger.warn message
    message
  end

  private

  def create_mutuo(producer, loan)
    creditor = OpenStruct.new(producer)
    mutuo_data = { user: loan.user, producer: creditor }
    producer_name = define_producer_name(creditor)
    mutuo = obtain_mutuo_generator(mutuo_data)
    legal_document = loan.legal_documents.create(
      kind: "#{creditor.mutuo_type.downcase}_mutuo",
      producer_name: producer_name,
      name: mutuo.file_name
    )
    pdf_manager = PdfManager.new(legal_document, mutuo)
    pdf_manager.attach_pdf
  end

  def create_oid_doc(loan)
    doc = OidGenerator.new(loan)
    legal_doc = loan.legal_documents.create(
      kind: 'oid',
      name: doc.file_name,
      producer_name: doc.producer_name
    )
    PdfManager.new(legal_doc, doc).attach_pdf
  end

  def obtain_mutuo_generator(mutuo_data)
    "#{mutuo_data[:producer].mutuo_type}MutuoGenerator".safe_constantize.new(mutuo_data)
  end

  def define_producer_name(creditor)
    case creditor.mutuo_type
    when 'Natural'
      creditor.first_name
    when 'Juridical' || 'Coperative'
      creditor.society_abbreviation
    end
  end
end
