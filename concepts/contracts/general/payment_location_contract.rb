# frozen_string_literal: true

module Contracts
  module General
    # Payment location Contract/Form Object
    class PaymentLocationContract < Contracts::BaseContractPatched
      property :lat
      property :long

      validates :lat, :long, presence: true
      validates :lat, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
      validates :long, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
    end
  end
end
