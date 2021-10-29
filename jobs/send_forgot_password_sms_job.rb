# frozen_string_literal: true

# Class to send SMS
class SendForgotPasswordSmsJob < ApplicationJob
  queue_as :notifications

  def perform(user_phone_number, new_password)
    client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: user_phone_number,
      body: "Tu contraseña provisional es: #{new_password} Ya puedes iniciar sesión con esta contraseña."
    )
  rescue StandardError
    message = "Forgot Password SMS couldn't be sent to #{user_phone_number}."
    Rails.logger.warn message
    message
  end
end
