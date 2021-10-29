# frozen_string_literal: true

class PatchedTokensController < Doorkeeper::TokensController
  def create
    headers.merge!(authorize_response.headers)
    response_body = authorize_response.body

    if authorize_response.status == :ok && authorize_response.token.resource_owner_id
      api_response = Operations::Me::ReferredCodeOwnerStatus.call(
        params: { user_id: authorize_response.actual_user.id }
      )
      response_body[:referred_code] = api_response[:response]
      response_body[:user_type] = authorize_response.actual_user.user_type_before_type_cast
    end

    render json: response_body, status: authorize_response.status
  rescue ::Doorkeeper::Errors::DoorkeeperError => e
    handle_token_exception(e)
  end
end
