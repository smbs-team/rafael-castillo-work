# frozen_string_literal:true

module Contracts
  # User with provider Contract/Form Object
  class UserWithProviderContract < Contracts::BaseContractPatched
    property :phone_number
    property :first_name
    property :last_name
    property :gender
    property :birth_date
    property :marital_status
    property :trade
    property :monthly_income

    validates :phone_number, :first_name, :last_name,
              :gender, :birth_date, :marital_status, :trade, presence: true
    validates :monthly_income, numericality: true, presence: true
  end
end
