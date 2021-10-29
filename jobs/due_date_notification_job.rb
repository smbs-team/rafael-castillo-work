# frozen_string_literal: true

# Class to send push notifications to installments due at 3 days
class DueDateNotificationJob < ApplicationJob
  queue_as :notifications

  def perform(hours)
    loans = get_loan(hours)

    loans.each do |loan|
      OneSignal::Notification.create(params: { include_player_ids: [signal_id(loan).to_s],
                                               contents: message(loan, hours),
                                               headings: title(hours),
                                               app_id: ENV['ONE_SIGNAL_APP_ID'] })
    rescue StandardError
      Rails.logger.warn "OneSignal notification creation failed for user with id #{loan.user.id}"
    end
  end

  private

  def get_loan(hours)
    Loan.where(current_installment_due_at: obtain_range(hours))
        .where('current_installment_amount > 0')
        .in_state(:active)
  end

  def title(hours)
    case hours
    when '72'
      {
        en: I18n.t('notifications.due_date.reminder.title')
      }
    when '0'
      {
        en: I18n.t('notifications.due_date.due.title')
      }
    end
  end

  def obtain_range(hours)
    due_date = Date.current.in_time_zone + hours.to_i.hours
    due_date..due_date.end_of_day
  end

  def message(loan, hours)
    case hours
    when '72'
      {
        en: "#{loan.user.first_name}, #{I18n.t('notifications.due_date.reminder.message')}"
      }
    when '0'
      {
        en: "#{loan.user.first_name}, #{I18n.t('notifications.due_date.due.message')}"
      }
    end
  end

  def signal_id(loan)
    loan&.user&.devices&.where(most_recent: true)&.first&.onesignal_id
  end
end
