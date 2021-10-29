# frozen_string_literal: true

module Contracts
  module Algorithm
    # Crowdfund Loan Contract/Form Object
    class CrowdfundLoanContract < Contracts::BaseContractPatched
      collection :producers, populator: :many_populator!, form: Contracts::Algorithm::ProducerContract

      validates :producers, presence: true
    end
  end
end
