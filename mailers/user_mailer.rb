# frozen_string_literal: true

# Mailer for User
class UserMailer < ApplicationMailer
  def activation_needed_email(user_email)
    user = User.find_by_email(user_email)
    @token = user.activation_token
    mail(
      to: user.email,
      subject: 'FIADO | Verifique su correo electrónico'
    ) do |format|
      format.html { render 'activation_needed_email' }
    end
  end

  def cancel_loan_email(loan_id, movement_status)
    @loan = Loan.find(loan_id)
    @user = @loan.user
    @status = movement_status
    mail(
      to: @user.email,
      subject: 'FIADO | Prestamo cancelado'
    ) do |format|
      format.html { render 'cancel_loan_email' }
    end
  end

  def legal_documents_email(loan_id)
    @loan = Loan.find(loan_id)
    @user = @loan.user
    attach_documents(@user)
    attach_documents(@loan)
    mail(
      to: @user.email,
      subject: 'FIADO | Documentos Legales'
    ) do |format|
      format.html { render 'legal_documents_email' }
    end
  end

  private

  def attach_documents(record)
    record.legal_documents.each do |legal_document|
      attachments["#{legal_document.name}.pdf"] = {
        mime_type: 'application/pdf',
        content: obtain_file(legal_document)
      }
    end
  end

  def obtain_file(legal_document)
    if %i[test local].include?(Rails.application.config.active_storage.service)
      legal_document.document.download
    else
      URI.open(legal_document.document_url).read
    end
  end
end
