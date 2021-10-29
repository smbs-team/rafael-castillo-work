# frozen_string_literal: true

module Operations
  # Operation that checks refill is available
  class RefillAvailabilityOperation < Paw::Operations::Api::Finder
    delegate :error!, to: Paw::Utils
    pass :fetch_loan!, after: :params!
    pass :check_current_installment_not_overdue!, after: :fetch_loan!
    pass :check_loan_percentage_paid!, after: :check_current_installment_not_overdue!
    pass :check_fiado_api!, after: :check_loan_percentage_paid!

    private

    def fetch_loan!(options, current_user:, **)
      options[:loan] = current_user.loans.in_state(:active).first

      return if options[:loan]

      error!(
        errors: { loan: 'user does not have an active loan' },
        status: 400
      )
    end

    def check_current_installment_not_overdue!(options, **)
      return if options[:loan].current_installment_amount <= 0

      error!(
        errors: { loan: 'current installment is not completely paid' },
        status: 422
      )
    end

    def check_loan_percentage_paid!(options, **)
      percentage = (ENV['REFILL_PERCENTAGE'].to_d * options[:loan].initial_amount.to_d)
      remaining_amount = options[:loan].initial_amount.to_d - percentage
      return if options[:loan].current_amount <= remaining_amount

      error!(
        errors: { loan: 'current amount is less than percentage needed' },
        status: 422
      )
    end

    def check_fiado_api!(_options, current_user:, **)
      data = Operations::FiadosDataOperation.call(
        api: 'algorithm',
        url: ENV['FIADOS_URL'],
        action: 'evaluate_refill',
        body_params: {
          "user_id": current_user.id
        }
      )

      return if data

      error!(
        errors: { fiado: 'user not approved for refill' },
        status: 422
      )
    end

    def present!(options, **)
      data = { message: 'refill available' }
      options[:response] = { data: data }
    end
  end
end
