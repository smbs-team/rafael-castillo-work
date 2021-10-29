# frozen_string_literal:true

module Contracts::Me
  class ReferredCodeConfirmation < Contracts::BaseContractPatched
    property :code
    property :userId

    validates :code, :userId, presence: true
  end
end
