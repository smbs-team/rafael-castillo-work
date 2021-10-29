# frozen_string_literal:true

module Contracts
  module Mts
    # Transaction Contract/Form Object
    class CheckTransactionContract < Contracts::BaseContractPatched
      property :user_dui_number
      property :code, documentation: { skip: true }

      validates :user_dui_number, :code, presence: true
    end
  end
end
