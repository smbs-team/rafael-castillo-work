# frozen_string_literal: true

module Api
  module V1
    class PaymentLocationsController < Api::V1::ApplicationController
      before_action :require_location_data!
      before_action { doorkeeper_authorize! :user }

      self.operation_class = {
        index: Operations::FinderWithContractOperation
      }.with_indifferent_access

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/payment_locations',
        method: 'get',
        collection: true,
        allowed_includes: allowed_includes,
        allowed_sorts: allowed_sorts,
        summary: 'Get closest locations to origin',
        tags: [
          'api/v1/payment_locations'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::General::PaymentLocationPresenter,
        contract: Contracts::General::PaymentLocationContract
      )

      private

      def fetch_options
        {
          params: params,
          model_class: PaymentLocation,
          contract_class: Contracts::General::PaymentLocationContract,
          presenter_class: Presenters::General::PaymentLocationPresenter,
          default_scope: lambda { |query|
                           Queries::PaymentLocationsQuery.new(query).call(params['data']['lat'],
                                                                          params['data']['long'])
                         }
        }
      end

      def require_location_data!
        return unless params['data'].blank?

        e = Paw::Exceptions::StandardError.new(
          message: 'Node data is required and can not be empty',
          status: 422,
          code: 422
        )
        raise e
      end
    end
  end
end
