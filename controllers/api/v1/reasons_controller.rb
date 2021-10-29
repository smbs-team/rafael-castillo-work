# frozen_string_literal: true

module Api
  module V1
    # Reasons Controller
    class ReasonsController < Api::V1::ApplicationController
      before_action do
        doorkeeper_authorize! :user
      end

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/reasons',
        method: 'get',
        collection: true,
        allowed_includes: allowed_includes,
        allowed_sorts: allowed_sorts,
        summary: 'List reasons',
        tags: [
          'api/v1/reasons'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::Common::ReasonPresenter
      )

      private

      def fetch_options
        {
          params: params.merge!(page: { size: 0 }),
          model_class: Reason,
          allowed_includes: self.class.allowed_includes,
          allowed_sorts: self.class.allowed_sorts,
          presenter_class: Presenters::Common::ReasonPresenter
        }
      end
    end
  end
end
