# frozen_string_literal:true

module Contracts
  module Mts
    # Transaction Contract/Form Object
    class CompletePaymentContract < Contracts::Mts::CompleteTransactionContract
      property :amount_paid

      validates :amount_paid, presence: true
      validates :amount_paid, numericality: { greater_than: 0 }
    end
  end
end
