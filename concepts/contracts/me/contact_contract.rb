# frozen_string_literal:true

module Contracts
  module Me
    # Contact Contract/Form Object
    class ContactContract < Contracts::BaseContractPatched
      property :device_id
      property :phone_number
      property :username
      validates :username, :phone_number, :device_id, presence: true
    end
  end
end
