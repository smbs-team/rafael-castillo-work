# frozen_string_literal:true

module Contracts
  module Me
    # Location Contract/Form Object
    class LocationContract < Contracts::BaseContractPatched
      property :lat
      property :long
      property :device_id
      validates :lat, :long, :device_id, presence: true
    end
  end
end
