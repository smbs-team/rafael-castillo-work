# frozen_string_literal:true

module Contracts
  # UserPasswordSmsContract Contract/Form Object
  class UserPasswordSmsContract < Contracts::BaseContractPatched
    property :phone_number
    property :dui

    validates :phone_number, presence: true, phone: true
    validates :dui, presence: true
  end
end
