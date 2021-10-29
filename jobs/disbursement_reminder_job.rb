# frozen_string_literal: true

# Class to send push notifications to installments due at 3 days
class DisbursementReminderJob < ApplicationJob
  queue_as :notifications

  def perform(hours)
    loans = get_loan(hours)
    loans.each do |loan|
      OneSignal::Notification.create(params: { include_player_ids: [signal_id(loan).to_s],
                                               contents: message(loan),
                                               headings: title,
                                               app_id: ENV['ONE_SIGNAL_APP_ID'] })
    rescue StandardError
      Rails.logger.warn "OneSignal notification creation failed for user with id #{loan.user.id}"
    end
  end

  private

  def get_loan(hours)
    Loan.in_state(:disbursed).select do |loan|
      obtain_range(hours).include?(loan.state_machine.last_transition.created_at)
    end
  end

  def title
    {
      en: I18n.t('notifications.disbursement.title')
    }
  end

  def obtain_range(hours)
    due_date = Date.current.in_time_zone - hours.to_i.hours
    due_date..(due_date + 24.hours)
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
