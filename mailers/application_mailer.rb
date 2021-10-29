# frozen_string_literal: true

# ApplicationMailer
class ApplicationMailer < ActionMailer::Base
  default from: 'info@fiadoapp.com'
  layout 'mailer'
end
