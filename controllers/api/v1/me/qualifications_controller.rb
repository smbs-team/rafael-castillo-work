# frozen_string_literal: true

module Api
  module V1
    module Me
      # Actions Controller
      class QualificationsController < Api::V1::Me::ApplicationController
        skip_before_action :require_data!, only: [:prequalify]

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/qualifications/prequalify',
          method: 'get',
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List contacts',
          tags: [
            'api/v1/me/qualifications'
          ],
          success_status: 200,
          error_responses: [400, 401, 422, 500],
          presenter: Presenters::Me::PrequalifyPresenter
        )

        def prequalify
          response = Operations::PrequalifyOperation.call(
            fetch_options
          )
          render json: response[:response], status: response[:status]
        end

        private

        def fetch_options
          {
            current_user: current_user,
            presenter_class: Presenters::Me::PrequalifyPresenter
          }
        end
      end
    end
  end
end
