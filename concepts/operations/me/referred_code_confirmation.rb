# frozen_string_literal: true

module Operations::Me
  class ReferredCodeConfirmation < Trailblazer::Operation
    delegate :error!, to: Paw::Utils
    pass :validate_contract!
    pass :obtain_data_from_api!
    pass :handle_response!

    private

    def validate_contract!(options, params:, **)
      contract = options[:contract_class].new(OpenStruct.new)
      valid = contract.validate(params[:data] || {})
      return if valid

      error!(errors: contract.errors, status: options[:error_status])
    end

    def obtain_data_from_api!(options, params:, **)
      uri = URI("#{ENV['FIADOS_NODEJS_API_URL']}codeConfirmationStatus")
      payload = {
        data: {
          code: params[:data][:code],
          userId: params[:data][:userId]
        }
      }.to_json

      response = Net::HTTP.post(uri, payload, 'Content-Type' => 'application/json')
      api_payload = JSON.parse(response.body)

      if response.code != '200'
        error_msg = api_payload['message'] || api_payload['error']['message']
        error!(status: 500, errors: { Api: "Request failed: #{error_msg}" })
      end

      options[:data] = api_payload['data']
    end

    def handle_response!(options, data:, **)
      options[:response] = { data: { result: data['renderStatus'] } }
    end
  end
end
