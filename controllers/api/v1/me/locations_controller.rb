# frozen_string_literal: true

module Api
  module V1
    module Me
      # Locations Controller
      class LocationsController < Api::V1::Me::ApplicationController
        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/locations',
          method: 'post',
          summary: 'Create a location',
          tags: [
            'api/v1/me/locations'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          contract: Contracts::Me::LocationContract,
          presenter: Presenters::Common::LocationPresenter
        )

        private

        def form_options
          {
            params: params,
            model_class: Location,
            current_user: current_user,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::LocationContract,
            presenter_class: Presenters::Common::LocationPresenter
          }
        end
      end
    end
  end
end
