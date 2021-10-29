# frozen_string_literal: true

# Class to send SMS
class SendVerificationSMSJob < ApplicationJob
  queue_as :default

  def perform(to, verification_code)
    client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: to,
      body: "Su número de confirmación de FIADO es: #{verification_code}"
    )
  rescue StandardError
    message = "Verification SMS couldn't be sent to #{to} phone number."
    Rails.logger.warn message
    message
  end
end
