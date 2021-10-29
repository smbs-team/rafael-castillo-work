# frozen_string_literal: true

# notifies producer portal of new loan
class LoanCreationJob < ApplicationJob
  def perform(params)
    Operations::FiadosDataOperation.call(
      api: 'producer',
      body_params: params,
      action: 'loans',
      url: ENV['FIADOS_PRODUCER_URL']
    )
  rescue StandardError
    message = 'Producer portal loan creation failed'
    Rails.logger.warn message
    message
  end
end
