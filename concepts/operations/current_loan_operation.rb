# frozen_string_literal: true

module Operations
  # add current user attr to model
  class CurrentLoanOperation < Paw::Operations::Api::Form
    pass :inject_current_loan!, before: :data!

    private

    def inject_current_loan!(_options, params:, current_user:, **)
      params['data']['loan_id'] = current_user.loans.in_state(:confirmed).first.id
    end
  end
end
