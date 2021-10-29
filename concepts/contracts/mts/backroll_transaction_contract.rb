# frozen_string_literal:true

module Contracts
  module Mts
    # Transaction Contract/Form Object
    class BackrollTransactionContract < Contracts::BaseContractPatched
      property :code, documentation: { skip: true }
      property :user_dui_number

      validates :code, :user_dui_number, presence: true
    end
  end
end
