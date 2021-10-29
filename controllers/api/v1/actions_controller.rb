# frozen_string_literal: true

module Api
  module V1
    # Actions Controller
    class ActionsController < Api::V1::ApplicationController
      before_action do
        doorkeeper_authorize! :user
      end

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/actions',
        method: 'get',
        collection: true,
        allowed_includes: allowed_includes,
        allowed_sorts: allowed_sorts,
        summary: 'List of all actions',
        tags: [
          'api/v1/actions'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::Common::ActionPresenter
      )

      private

      def fetch_options
        {
          params: params.merge!(page: { size: 0 }),
          model_class: Action,
          allowed_includes: self.class.allowed_includes,
          allowed_sorts: self.class.allowed_sorts,
          presenter_class: Presenters::Common::ActionPresenter
        }
      end
    end
  end
end
