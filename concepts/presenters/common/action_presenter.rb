# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for Action model
    class ActionPresenter < Paw::Presenters::Api::BasePresenter
      property :id
      property :label
    end
  end
end
