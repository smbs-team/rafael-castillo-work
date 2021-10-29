# frozen_string_literal: true

module Operations::Me
  class ReferredCodeOwnerStatus < Trailblazer::Operation
    pass :obtain_data_from_api!

    private

    def obtain_data_from_api!(options, params:, **)
      uri = URI("#{ENV['FIADOS_NODEJS_API_URL']}codeOwnerStatus")
      payload = { data: { userId: params[:user_id] } }.to_json

      response = Net::HTTP.post(uri, payload, 'Content-Type' => 'application/json')
      api_payload = JSON.parse(response.body)

      if response.code != '200'
        error_msg = api_payload['message'] || api_payload['error']['message']
        options[:response] = { errors: [{ field_name: 'Api', message: error_msg }] }
      else
        options[:response] = api_payload['data']
      end
    rescue JSON::ParserError
      options[:response] = { errors: [{ field_name: 'Api', message: "Failed to get JSON data at #{uri}" }] }
    end
  end
end
