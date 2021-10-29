# frozen_string_literal: true

module Operations
  # Operation to use fiados api
  class FiadosDataOperation < Trailblazer::Operation
    delegate :error!, to: Paw::Utils
    pass :obtain_response!
    pass :present!

    private

    def obtain_response!(options, action:, url:, api:, body_params:, **) # rubocop:disable Metrics
      uri = URI(url + action)
      token = ApiAuthenticatorService.new.call(api)

      response = Net::HTTP.post(
        uri,
        body_params.to_json,
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      )

      response = JSON.parse(response.body)

      if response['error']
        error!(
          errors: { Api: 'Request failed' },
          status: 500
        )
      end

      options[:data] = response['data']
    end

    def present!(options, data:, **)
      options[:response] = data.to_hash
    end
  end
end
