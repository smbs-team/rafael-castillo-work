# frozen_string_literal: true

module Api
  module V1
    module Algorithm
      # Answers Controller
      class AnswersController < Api::V1::Algorithm::ApplicationController
        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/algorithm/users/:id/answers',
          method: 'get',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List questions and its answers',
          tags: [
            'api/v1/algorithm/users'
          ],
          success_status: 200,
          error_responses: [400, 401, 404, 422, 500],
          presenter: Presenters::Common::AnswerPresenter
        )

        private

        def fetch_options
          {
            params: params.merge!(filter: { user_id_eq: params[:user_id] }),
            model_class: Answer,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Common::AnswerPresenter
          }
        end
      end
    end
  end
end
