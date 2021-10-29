# frozen_string_literal: true

# Send notifications
class MutuosAreReadyJob < ApplicationJob
  queue_as :notifications

  def perform(id)
    loan = Loan.find(id)

    OneSignal::Notification.create(params: { include_player_ids: [signal_id(loan).to_s],
                                             contents: message,
                                             headings: title,
                                             app_id: ENV['ONE_SIGNAL_APP_ID'] })
  rescue StandardError
    Rails.logger.warn 'OneSignal notification creation failed'
  end

  private

  def message
    {
      en: I18n.t('notifications.mutuos.message')
    }
  end

  def title
    {
      en: I18n.t('notifications.mutuos.title')
    }
  end

  def signal_id(loan)
    loan&.user&.devices&.where(most_recent: true)&.first&.onesignal_id
  end
end
