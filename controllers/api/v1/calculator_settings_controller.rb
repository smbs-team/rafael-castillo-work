# frozen_string_literal: true

module Api
  module V1
    # Calculator Controller
    class CalculatorSettingsController < Api::V1::ApplicationController
      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/calculator_settings',
        method: 'get',
        collection: true,
        allowed_includes: allowed_includes,
        allowed_sorts: allowed_sorts,
        summary: 'List calculator_settings',
        tags: [
          'api/v1/calculator_settings'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::Common::CalculatorSettingPresenter
      )

      # Temproraty mock this method. To rollback this monkey patch it's enought to remove this method
      def index # rubocop:disable Metrics/MethodLength
        fake_data = {
          data: [
            {
              max_terms: 0,
              min_terms: 0,
              max_amount: '0',
              min_amount: '0',
              interest_rate: '0',
              default_amount: '0',
              default_terms: 0,
              id: 2
            }
          ],
          meta: { current_page: 1, from: 0, last_page: 0, per_page: 0, to: 0, total: 1 }
        }

        render json: fake_data
      end

      private

      def fetch_options
        {
          params: params,
          model_class: CalculatorSetting,
          allowed_includes: self.class.allowed_includes,
          allowed_sorts: self.class.allowed_sorts,
          presenter_class: Presenters::Common::CalculatorSettingPresenter
        }
      end
    end
  end
end
