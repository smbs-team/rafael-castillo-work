# frozen_string_literal: true

module Contracts
  module Me
    # Answer Contract/Form Object
    class AnswerContract < Contracts::BaseContractPatched
      property :answer
      validates :answer, presence: true
    end
  end
end
