# frozen_string_literal: true

module Api
  module V1
    module Me
      # Identities Controller
      class IdentitiesController < Api::V1::Me::ApplicationController
        self.operation_class = {
          index: Paw::Operations::Api::Finder,
          show: Paw::Operations::Api::Finder,
          create: Operations::CreateIdentity,
          update: Operations::Me::UpdateOwnedResourceOperation
        }.with_indifferent_access

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/identities',
          method: 'get',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List identities',
          tags: [
            'api/v1/me/identities'
          ],
          success_status: 200,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::IdentityPresenter
        )

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/identities',
          method: 'post',
          summary: 'Create an identity for the signed in user.',
          tags: [
            'api/v1/me/identities'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::IdentityPresenter,
          contract: Contracts::Me::IdentityContract
        )

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/identities/:id',
          method: 'patch',
          summary: 'Update an identity for the user.',
          tags: [
            'api/v1/me/identities'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::IdentityPresenter,
          contract: Contracts::Me::IdentityContract
        )

        private

        def form_options
          {
            params: params,
            model_class: Identity,
            current_user: current_user,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::IdentityContract,
            presenter_class: Presenters::Me::IdentityPresenter
          }
        end

        def fetch_options
          {
            params: params.merge!(page: { size: 0 }),
            model_class: Identity,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Me::IdentityPresenter,
            default_scope: lambda { |query|
              Queries::Commons::CurrentUserQuery.new(query).call(current_user.id)
            }
          }
        end
      end
    end
  end
end
