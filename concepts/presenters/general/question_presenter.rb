# frozen_string_literal: true

module Presenters
  module General
    # Serializer/presenter for Question model
    class QuestionPresenter < Paw::Presenters::Api::BasePresenter
      property :id
      property :label
    end
  end
end
