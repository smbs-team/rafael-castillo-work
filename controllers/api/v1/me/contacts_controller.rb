# frozen_string_literal: true

module Api
  module V1
    module Me
      # Contacts Controller
      class ContactsController < Api::V1::Me::ApplicationController
        self.allowed_sorts = %w[username phone_number]

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/contacts',
          method: 'post',
          summary: 'Create a contact',
          tags: [
            'api/v1/me/contacts'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Common::ContactPresenter,
          contract: Contracts::Me::ContactContract
        )

        private

        def form_options
          {
            params: params,
            model_class: Contact,
            current_user: current_user,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::ContactContract,
            presenter_class: Presenters::Common::ContactPresenter
          }
        end
      end
    end
  end
end
