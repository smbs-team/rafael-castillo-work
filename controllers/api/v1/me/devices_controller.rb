# frozen_string_literal: true

module Api
  module V1
    module Me
      # Device Controller
      class DevicesController < Api::V1::Me::ApplicationController # rubocop:disable Metrics/ClassLength
        before_action :require_query!, only: %i[index]

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/devices',
          method: 'get',
          collection: true,
          query: %w[
            uuid
            imei
          ],
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List of Devices.',
          tags: [
            'api/v1/me/devices'
          ],
          success_status: 200,
          error_responses: [400, 401, 422, 500],
          presenter: Presenters::Me::DevicePresenter
        )

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/devices',
          method: 'post',
          summary: 'Create a Device.',
          tags: [
            'api/v1/me/devices'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::DevicePresenter,
          contract: Contracts::Me::DeviceContract
        )

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/devices/:device_id/sms_sync_date',
          method: 'patch',
          summary: 'Update sync dates of the device.',
          tags: [
            'api/v1/me/devices'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::UpdateDeviceMessageSyncPresenter,
          contract: Contracts::Me::UpdateDeviceMessageSyncContract
        )

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/devices/:device_id/contacts_sync_date',
          method: 'patch',
          summary: 'Update sync dates of the contacts.',
          tags: [
            'api/v1/me/devices'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::UpdateDeviceContactsSyncPresenter,
          contract: Contracts::Me::UpdateDeviceContactsSyncContract
        )

        def sms_sync_date
          response = Operations::CurrentDeviceOperation.call(
            form_options_message_sync_date
          )
          render json: response[:response], status: response[:status]
        end

        def contacts_sync_date
          response = Operations::CurrentDeviceOperation.call(
            form_options_contacts_sync_date
          )
          render json: response[:response], status: response[:status]
        end

        private

        def form_options_message_sync_date
          {
            params: params,
            model_class: Device,
            device_id: params[:device_id],
            contract_class: Contracts::Me::UpdateDeviceMessageSyncContract,
            presenter_class: Presenters::Me::UpdateDeviceMessageSyncPresenter
          }
        end

        def form_options_contacts_sync_date
          {
            params: params,
            model_class: Device,
            device_id: params[:device_id],
            contract_class: Contracts::Me::UpdateDeviceContactsSyncContract,
            presenter_class: Presenters::Me::UpdateDeviceContactsSyncPresenter
          }
        end

        def form_options
          {
            params: params,
            model_class: Device,
            current_user: current_user,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::DeviceContract,
            presenter_class: Presenters::Me::DevicePresenter
          }
        end

        def fetch_options
          {
            params: params.merge!(page: { size: 0 }),
            model_class: Device,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Me::DevicePresenter,
            default_scope: lambda { |query|
              Queries::Me::UserDevicesQuery.new(query).call(current_user.id, params[:imei], params[:uuid])
            }
          }
        end

        def require_query!
          return unless params['imei'].blank? || params['uuid'].blank?

          e = Paw::Exceptions::StandardError.new(
            message: 'Query value imei and uuid are required and can not be empty',
            status: 400,
            code: 400
          )
          raise e
        end
      end
    end
  end
end
