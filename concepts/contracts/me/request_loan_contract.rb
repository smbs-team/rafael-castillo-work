# frozen_string_literal: true

module Contracts
  module Me
    # Request Loan Contract/Form Object
    class RequestLoanContract < Contracts::BaseContractPatched
      property :amount_requested
      property :installments

      validates :amount_requested, :installments, presence: true
      validates :amount_requested, numericality: { greater_than: :installments }
      validates :installments, numericality: { greater_than: 0 }
    end
  end
end
