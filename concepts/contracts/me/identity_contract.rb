# frozen_string_literal:true

module Contracts
  module Me
    # Idenditity Contract/Form Object
    class IdentityContract < Contracts::BaseContractPatched
      property :user_id
      property :provider
      property :auth_token
      validates :auth_token, :provider, presence: true
    end
  end
end
