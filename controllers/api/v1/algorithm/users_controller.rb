# frozen_string_literal: true

module Api
  module V1
    module Algorithm
      # Users Controller
      class UsersController < Api::V1::Algorithm::ApplicationController
        skip_before_action :require_data!, only: [:budget]

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/algorithm/users/:id',
          method: 'get',
          summary: 'Show user basic information',
          tags: [
            'api/v1/algorithm/users'
          ],
          success_status: 200,
          error_responses: [400, 401, 404, 422, 500],
          presenter: Presenters::Common::UserPresenter
        )

        private

        def fetch_options
          {
            params: params,
            model_class: User,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Common::UserPresenter
          }
        end
      end
    end
  end
end
