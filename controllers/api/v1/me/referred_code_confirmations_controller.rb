# frozen_string_literal: true

module Api::V1::Me
  class ReferredCodeConfirmationsController < Api::V1::Me::ApplicationController
    Paw::SwaggerDoc.endpoint(
      path: '/api/v1/me/referred_code_confirmation',
      method: 'post',
      summary: 'Confirm the referred code',
      collection: false,
      tags: [
        'api/v1/me/referred_code_confirmation'
      ],
      success_status: 200,
      error_responses: [422, 500],
      presenter: Presenters::Me::ReferredCodeConfirmationPresenter,
      contract: Contracts::Me::ReferredCodeConfirmation
    )

    def create
      response = Operations::Me::ReferredCodeConfirmation.call(confirmation_options)
      render json: response[:response], status: response[:status]
    end

    private

    def confirmation_options
      {
        params: params,
        contract_class: Contracts::Me::ReferredCodeConfirmation
      }
    end
  end
end
