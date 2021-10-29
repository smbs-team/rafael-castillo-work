# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for Reason model
    class ReasonPresenter < Paw::Presenters::Api::BasePresenter
      property :id
      property :label
    end
  end
end
