# frozen_string_literal:true

module Contracts
  # UserPhone Contract/Form Object
  class UserPhoneContract < Contracts::BaseContractPatched
    property :phone_number

    validates :phone_number, presence: true, phone: true
    validate :phone_number_not_registered

    def phone_number_not_registered
      return if User.where(phone_number: phone_number).empty?

      errors.add(:phone_nunmer, 'Phone number already linked to a user')
    end
  end
end
