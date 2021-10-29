# frozen_string_literal:true

module Contracts
  # User Contract/Form Object
  class UpdateUserContract < Contracts::BaseContractPatched
    property :first_name
    property :last_name
    property :monthly_income
    property :truthful_information
    property :email
    property :gender
    property :birth_date
    property :marital_status
    property :trade
    property :segment_id
    property :user_type, documentation: { type: :integer }
    validates :email, email: true

    # casting "1" => 1, not cahnging "person" and "enterprise"
    def user_type=(value)
      cast =
        if value && value.to_s.strip == value.to_i.to_s
          value.to_i
        else
          value
        end

      super cast
    end
  end
end
