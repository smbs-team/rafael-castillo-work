# frozen_string_literal: true

module Presenters
  # Serializer/presenter for 204 responses
  class EmptyPresenter < Paw::Presenters::Api::BasePresenter
    @swagger_properties = {}
  end
end
