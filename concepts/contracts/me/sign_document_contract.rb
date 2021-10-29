# frozen_string_literal: true

module Contracts
  module Me
    # SignDocument Contract/Form Object
    class SignDocumentContract < Contracts::BaseContractPatched
      property :signature
      property :documents_ids, documentation: { type: :array, items: { type: :string } }

      validates :documents_ids, presence: true, array_of_numbers: true
      validates :signature, presence: true, mime_type: { in: %w[image/jpeg image/png] }
    end
  end
end
