# frozen_string_literal:true

module Contracts
  module Me
    # SMS Contract/Form Object
    class SmsContract < Contracts::BaseContractPatched
      property :device_id
      property :message
      property :sender
      property :read_state
      property :time
      property :folder
      property :message_internal_id
      validates :read_state, :time, :folder, :device_id, presence: true
    end
  end
end
