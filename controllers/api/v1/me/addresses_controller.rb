# frozen_string_literal: true

module Api
  module V1
    module Me
      # Addresses Controller
      class AddressesController < Api::V1::Me::ApplicationController
        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/addresses',
          method: 'post',
          summary: 'Create an address for current user',
          tags: [
            'api/v1/me/addresses'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::AddressPresenter,
          contract: Contracts::Me::AddressContract
        )

        private

        def form_options
          {
            params: params,
            model_class: Address,
            current_user: current_user,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::AddressContract,
            presenter_class: Presenters::Me::AddressPresenter
          }
        end
      end
    end
  end
end
