# frozen_string_literal:true

# user's bank account number and bank
class BankAccount < ApplicationRecord
  belongs_to :user
end
