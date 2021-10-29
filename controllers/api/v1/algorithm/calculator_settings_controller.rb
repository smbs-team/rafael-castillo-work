# frozen_string_literal: true

module Api
  module V1
    module Algorithm
      # Calculator Controller
      class CalculatorSettingsController < Api::V1::ApplicationController
        Paw::SwaggerDoc.endpoint(
          path: 'api/v1/algorithm/calculator_settings',
          method: 'patch',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List calculator_settings',
          tags: [
            'api/v1/algorithm/calculator_settings'
          ],
          success_status: 200,
          error_responses: [401, 422, 500],
          presenter: Presenters::Common::CalculatorSettingPresenter
        )

        private

        def form_options
          {
            params: params,
            model_class: CalculatorSetting,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Algorithm::CalculatorSettingContract,
            presenter_class: Presenters::Common::CalculatorSettingPresenter
          }
        end
      end
    end
  end
end
