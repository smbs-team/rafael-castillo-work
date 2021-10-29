# frozen_string_literal: true

module Contracts
  module Me
    # Update/Change user password
    class ChangePassword < Contracts::BaseContractPatched
      property :new_password
      property :current_password

      validates :new_password, :current_password, presence: true
    end
  end
end
