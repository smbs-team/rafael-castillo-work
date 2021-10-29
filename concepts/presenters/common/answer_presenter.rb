# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for Question model
    class AnswerPresenter < Paw::Presenters::Api::BasePresenter
      property :question_id
      property :label, exec_context: :decorator
      property :answer
      property :id

      def label
        represented.question.label
      end
    end
  end
end
