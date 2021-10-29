# frozen_string_literal:true

module Contracts
  module Me
    # Personal Document Contract/Form Object
    class PersonalDocumentContract < Contracts::BaseContractPatched
      property :user_id, documentation: { skip: true }
      property :kind
      property :number
      property :document_images, documentation: { type: :object, items: { type: :string } }
      validates :kind, :number, presence: true
      validates :document_images, if: -> { document_images.present? }, hash_of_images: true
    end
  end
end
