# frozen_string_literal: true

module Contracts
  module Me
    # ActionDevice Contract/Form Object
    class ActionDeviceContract < Contracts::BaseContractPatched
      property :device_id
      property :action_id
    end
  end
end
