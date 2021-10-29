# frozen_string_literal:true

module Contracts
  # User with provider Contract/Form Object
  class UserWithProviderContractForDoc < Contracts::BaseContractPatched
    property :phone_number
    property :token
    property :provider

    validates :phone_number, :token, :provider, presence: true
  end
end
