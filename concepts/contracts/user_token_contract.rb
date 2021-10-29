# frozen_string_literal:true

module Contracts
  # User Token Contract/Form Object
  class UserTokenContract < Contracts::BaseContractPatched
    property :token

    validates :token, presence: true
  end
end
