# frozen_string_literal: true

module Api
  module V1
    module Me
      # Actions Controller
      class ActionsController < Api::V1::Me::ApplicationController
        self.operation_class = {
          index: Paw::Operations::Api::Finder,
          show: Paw::Operations::Api::Finder,
          create: Paw::Operations::Api::Form,
          update: Operations::CurrentUserOperation
        }.with_indifferent_access

        before_action :require_query!, only: %i[index]

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/actions',
          method: 'get',
          collection: true,
          query: [
            'device_id'
          ],
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List of actions per user',
          tags: [
            'api/v1/me/actions'
          ],
          success_status: 200,
          error_responses: [400, 401, 422, 500],
          presenter: Presenters::Common::ActionPresenter
        )

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/actions',
          method: 'post',
          summary: 'Create an action per device',
          tags: [
            'api/v1/me/actions'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::DeviceActionPresenter,
          contract: Contracts::Me::ActionDeviceContract
        )

        private

        def fetch_options
          {
            params: params.merge!(page: { size: 0 }),
            model_class: Action,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Common::ActionPresenter,
            default_scope: lambda { |query|
              Queries::Me::CurrentUserDeviceActionsQuery.new(query).call(current_user.id, params[:device_id])
            }
          }
        end

        def form_options
          {
            params: params,
            model_class: DeviceAction,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::ActionDeviceContract,
            presenter_class: Presenters::Me::DeviceActionPresenter
          }
        end

        def require_query!
          return unless params['device_id'].blank?

          e = Paw::Exceptions::StandardError.new(
            message: 'Query value device_id is required and can not be empty',
            status: 400,
            code: 400
          )
          raise e
        end
      end
    end
  end
end
