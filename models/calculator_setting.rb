# frozen_string_literal: true

# Calculator values settings
class CalculatorSetting < ApplicationRecord
  has_paper_trail

  validates :min_terms, :min_amount, :interest_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :max_terms, numericality: { greater_than_or_equal_to: :min_terms }
  validates :max_amount, numericality: { greater_than_or_equal_to: :min_amount }
end
