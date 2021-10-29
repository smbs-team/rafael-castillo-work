# frozen_string_literal: true

module Contracts
  module Me
    # Answer Contract/Form Object
    class CreateAnswerContract < Contracts::BaseContractPatched
      property :answer
      property :question_id
      property :user_id, documentation: { skip: true }
      validates :answer, presence: true
    end
  end
end
