# frozen_string_literal:true

module Contracts
  module Mts
    # Transaction Contract/Form Object
    class CompleteTransactionContract < Contracts::BaseContractPatched
      property :reference_code
      property :code, documentation: { skip: true }
      property :user_dui_number

      validates :reference_code, :code, :user_dui_number, presence: true
    end
  end
end
