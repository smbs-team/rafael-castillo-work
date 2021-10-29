# frozen_string_literal: true

module Api::V1::Me
  class ReferredCodeCheckingsController < Api::V1::Me::ApplicationController
    Paw::SwaggerDoc.endpoint(
      path: '/api/v1/me/referred_code_checking',
      method: 'post',
      summary: 'Validate a referred code',
      collection: true,
      tags: [
        'api/v1/me/referred_code_checking'
      ],
      success_status: 200,
      error_responses: [422, 500],
      presenter: Presenters::Me::ReferredCodeCheckingPresenter,
      contract: Contracts::Me::ReferredCodeChecking
    )

    def create
      response = Operations::Me::ReferredCodeChecking.call(checking_options)
      render json: response[:response], status: response[:status]
    end

    private

    def checking_options
      {
        params: params,
        contract_class: Contracts::Me::ReferredCodeChecking
      }
    end
  end
end
