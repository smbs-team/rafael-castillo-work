# frozen_string_literal:true

module Contracts
  module Algorithm
    # CalculatorSetting Contract/Form Object
    class CalculatorSettingContract < Contracts::BaseContractPatched
      property :max_terms
      property :min_terms
      property :max_amount
      property :min_amount
      property :interest_rate
      property :default_terms
      property :default_amount
    end
  end
end
