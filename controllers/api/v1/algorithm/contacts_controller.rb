# frozen_string_literal: true

module Api
  module V1
    module Algorithm
      # Contacts Controller
      class ContactsController < Api::V1::Algorithm::ApplicationController
        self.allowed_sorts = %w[username phone_number]

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/algorithm/users/:id/contacts',
          method: 'get',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List contacts',
          tags: [
            'api/v1/algorithm/users'
          ],
          success_status: 200,
          error_responses: [400, 401, 404, 422, 500],
          presenter: Presenters::Common::ContactPresenter
        )

        private

        def fetch_options
          {
            params: params,
            model_class: Contact,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Common::ContactPresenter,
            default_scope: lambda { |query|
              Queries::Algorithm::UserDataFromDevicesQuery.new(query).call(params[:user_id])
            }
          }
        end
      end
    end
  end
end
