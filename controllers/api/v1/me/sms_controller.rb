# frozen_string_literal: true

module Api
  module V1
    module Me
      # Sms Controller
      class SmsController < Api::V1::Me::ApplicationController
        self.operation_class = {
          index: Paw::Operations::Api::Finder,
          show: Paw::Operations::Api::Finder,
          create: Paw::Operations::Api::Form,
          update: Operations::CurrentUserOperation
        }.with_indifferent_access

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/sms',
          method: 'post',
          summary: 'Create an SMS',
          tags: [
            'api/v1/me/sms'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Common::SmsPresenter,
          contract: Contracts::Me::SmsContract
        )

        private

        def form_options
          {
            params: params,
            model_class: Sms,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::SmsContract,
            presenter_class: Presenters::Common::SmsPresenter
          }
        end
      end
    end
  end
end
