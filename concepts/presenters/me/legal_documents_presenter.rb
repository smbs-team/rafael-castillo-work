# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for Legal Documents
    class LegalDocumentsPresenter < Paw::Presenters::Api::BasePresenter
      property :id
      property :producer_name
      property :signed
      property :url, exec_context: :decorator
      property :kind, as: :document_type

      def url
        return nil unless represented.document.attached?

        represented.document_url
      end
    end
  end
end
