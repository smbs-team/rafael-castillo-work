# frozen_string_literal:true

module Contracts::Me
  class ReferredCodeChecking < Contracts::BaseContractPatched
    property :code
    property :userType

    validates :code, :userType, presence: true
    validates :userType, numericality: true
  end
end
