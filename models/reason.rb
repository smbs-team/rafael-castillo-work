# frozen_string_literal: true

# Loan's reasons
class Reason < ApplicationRecord
  has_many :loan_reasons
  has_many :loans, through: :loan_reasons
end
