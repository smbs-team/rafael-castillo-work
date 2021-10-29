# frozen_string_literal: true

module Api
  module V1
    # Questions Controller
    class QuestionsController < Api::V1::ApplicationController
      before_action do
        doorkeeper_authorize! :user
      end
      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/questions',
        method: 'get',
        collection: true,
        allowed_includes: allowed_includes,
        allowed_sorts: allowed_sorts,
        summary: 'List of all questions',
        tags: [
          'api/v1/questions'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::General::QuestionPresenter
      )

      private

      def fetch_options
        {
          params: params,
          model_class: Question,
          allowed_includes: self.class.allowed_includes,
          allowed_sorts: self.class.allowed_sorts,
          presenter_class: Presenters::General::QuestionPresenter
        }
      end
    end
  end
end
