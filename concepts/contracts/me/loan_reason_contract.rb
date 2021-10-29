# frozen_string_literal: true

module Contracts
  module Me
    # LoanReason Contract/Form Object
    class LoanReasonContract < Contracts::BaseContractPatched
      property :loan_id, documentation: { skip: true }
      property :reason_id

      validates :reason_id, presence: true
    end
  end
end
