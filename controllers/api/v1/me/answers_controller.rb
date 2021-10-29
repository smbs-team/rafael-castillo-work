# frozen_string_literal: true

module Api
  module V1
    module Me
      # Answers Controller
      class AnswersController < Api::V1::Me::ApplicationController
        Paw::SwaggerDoc.endpoint(
          path: 'api/v1/me/answers',
          method: 'get',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List of answers per user',
          tags: [
            'api/v1/me/answers'
          ],
          success_status: 200,
          error_responses: [400, 401, 422, 500],
          presenter: Presenters::Common::AnswerPresenter
        )

        Paw::SwaggerDoc.endpoint(
          path: 'api/v1/me/answers',
          method: 'post',
          summary: 'Create a question/answer',
          tags: [
            'api/v1/me/answers'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Common::AnswerPresenter,
          contract: Contracts::Me::CreateAnswerContract
        )

        Paw::SwaggerDoc.endpoint(
          path: 'api/v1/me/answers/:id',
          method: 'patch',
          summary: 'Update an answer',
          tags: [
            'api/v1/me/answers'
          ],
          success_status: 200,
          error_responses: [401, 422, 500],
          presenter: Presenters::Common::AnswerPresenter,
          contract: Contracts::Me::AnswerContract
        )

        def create
          response = Operations::CurrentUserOperation.call(
            form_options_for_create
          )
          render json: response[:response], status: 201
        end

        private

        def fetch_options
          {
            params: params.merge!(page: { size: 0 }),
            model_class: Answer,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Common::AnswerPresenter,
            default_scope: lambda { |query|
              Queries::Commons::CurrentUserQuery.new(query).call(current_user.id)
            }
          }
        end

        def form_options
          {
            params: params,
            current_user: current_user,
            model_class: Answer,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::AnswerContract,
            presenter_class: Presenters::Common::AnswerPresenter
          }
        end

        def form_options_for_create
          {
            params: params,
            current_user: current_user,
            model_class: Answer,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::CreateAnswerContract,
            presenter_class: Presenters::Common::AnswerPresenter
          }
        end
      end
    end
  end
end
