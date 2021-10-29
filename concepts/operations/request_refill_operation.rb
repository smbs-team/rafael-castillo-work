# frozen_string_literal: true

module Operations
  # Operation to get prequalification for user
  class RequestRefillOperation < Operations::RequestLoanOperation
    pass :set_action!, override: true

    private

    def set_action!(options, **)
      options[:action] = 'refill'
    end
  end
end
