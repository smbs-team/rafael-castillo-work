# frozen_string_literal: true

module Operations
  # Creates Personal Document
  class CreatePersonalDocumentOperation < Paw::Operations::Api::Form
    pass :inject_user_id!, after: :validate!
    pass :extract_images_from_hash!, after: :inject_user_id!

    private

    def inject_user_id!(options, current_user:, **)
      options[:contract].user_id = current_user.id
    end

    def extract_images_from_hash!(_options, contract:, params:, **)
      contract.document_images = params[:data][:document_images].values unless params[:data][:document_images].blank?
    end
  end
end
