# frozen_string_literal: true

# Class to send push notifications to installments due at 3 days
class DisbursementAboutToExpireReminderJob < ApplicationJob
  queue_as :notifications

  def perform(loan_id)
    loan = Loan.find(loan_id)
    return unless loan.status == 'disbursed'

    OneSignal::Notification.create(params: { include_player_ids: [signal_id(loan).to_s],
                                             contents: message(loan),
                                             headings: title,
                                             app_id: ENV['ONE_SIGNAL_APP_ID'] })
  rescue StandardError
    Rails.logger.warn "OneSignal notification creation failed for loan with id #{loan_id}"
  end

  private

  def title
    {
      en: I18n.t('notifications.disbursement.title')
    }
  end

  def message(loan)
    {
      en: "#{loan.user.first_name}, #{I18n.t('notifications.disbursement.message')}"
    }
  end

  def signal_id(loan)
    loan&.user&.devices&.where(most_recent: true)&.first&.onesignal_id
  end
end
