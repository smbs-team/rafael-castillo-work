# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

# Calculates the interest extracted from a payment using IPMT formula
class InterestCalculatorService < ApplicationService
  def call(loan)
    monthly_interest = loan.current_interest_rate.to_d / 100
    loan.current_amount * monthly_interest
  end
end
