# frozen_string_literal:true

module Contracts
  module Me
    # Address Contract/Form Object
    class AddressContract < Contracts::BaseContractPatched
      property :user_id, documentation: { skip: true }
      property :city
      property :state
      property :zip_code
      property :street
      property :country
      validates :street, :city, :state, :zip_code, :state, :country, presence: true
    end
  end
end
