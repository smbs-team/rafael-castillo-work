# frozen_string_literal: true

# Reasons taken per loan
class LoanReason < ApplicationRecord
  belongs_to :loan
  belongs_to :reason

  validates_uniqueness_of :loan_id
end
