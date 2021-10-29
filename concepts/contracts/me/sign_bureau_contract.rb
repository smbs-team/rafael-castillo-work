# frozen_string_literal: true

module Contracts
  module Me
    # Sign bureau document Contract/Form Object
    class SignBureauContract < Contracts::BaseContractPatched
      property :signature

      validates :signature, presence: true, mime_type: { in: %w[image/jpeg image/png] }
    end
  end
end
