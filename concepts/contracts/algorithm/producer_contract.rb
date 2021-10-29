# frozen_string_literal:true

module Contracts
  module Algorithm
    # Producer Contract/Form Object
    class ProducerContract < Contracts::BaseContractPatched
      property :mutuo_type
      property :first_name
      property :last_name
      property :gender
      property :signature
      property :birth_date
      property :trade
      property :amount
      property :city
      property :state
      property :dui
      property :nit
      property :society_nit
      property :society_full_name
      property :society_abbreviation
      property :society_state
      property :society_city

      validates :first_name, :last_name, :signature, :gender, :birth_date, :amount,
                :trade, :state, :city, :dui, :nit, :mutuo_type, presence: true

      with_options if: -> { mutuo_type == 'Cooperative' || mutuo_type == 'Juridical' } do
        validates :society_abbreviation,
                  :society_city,
                  :society_full_name,
                  :society_nit,
                  :society_state,
                  presence: true
      end

      validates :gender, gender: true
      validates :mutuo_type, mutuo_type: true
    end
  end
end
