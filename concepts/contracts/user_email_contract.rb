# frozen_string_literal:true

module Contracts
  # User Contract/Form Object
  class UserEmailContract < Contracts::BaseContractPatched
    property :email

    validates :email, presence: true, email: true
  end
end
