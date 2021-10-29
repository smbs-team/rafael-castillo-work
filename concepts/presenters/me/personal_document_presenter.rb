# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for Document model
    class PersonalDocumentPresenter < Paw::Presenters::Api::BasePresenter
      property :kind
      property :number
      property :document_image_urls, exec_context: :decorator, render_nil: false

      def document_image_urls
        return nil unless represented.document_images.attached?

        represented.document_images_urls
      end
    end
  end
end
