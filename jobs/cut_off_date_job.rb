# frozen_string_literal: true

# Job to implement
class CutOffDateJob < ApplicationJob
  queue_as :critical

  def perform
    loans = Loan.where(current_installment_due_at: obtain_range).in_state(:active)
    loans.each do |loan|
      ActiveRecord::Base.transaction do
        Operations::Transactions::CutOffDateOperation.call(
          loan: loan
        )
      end
    end
  end

  def obtain_range
    Date.current.in_time_zone.beginning_of_day..Date.current.in_time_zone.end_of_day
  end
end
