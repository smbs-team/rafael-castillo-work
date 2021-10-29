# frozen_string_literal:true

module Contracts
  # User Contract/Form Object
  class UserContract < Contracts::BaseContractPatched
    property :first_name
    property :last_name
    property :gender
    property :birth_date
    property :marital_status
    property :trade
    property :monthly_income
    property :email
    property :phone_number
    property :password
    property :user_type, documentation: { type: :integer }

    validates :phone_number, :first_name, :last_name, :email, :password,
              :gender, :birth_date, :marital_status, :trade, :user_type, presence: true
    validates :monthly_income, numericality: true, presence: true
    validates :email, email: true

    validate :user_type_param_must_present!

    def user_type=(value)
      cast =
        if value && value.to_s.strip == value.to_i.to_s
          value.to_i
        else
          value
        end

      super cast
    end

    def user_type_param_must_present!
      errors.add :user_type, "can't be blank" unless changed['user_type']
    end
  end
end
