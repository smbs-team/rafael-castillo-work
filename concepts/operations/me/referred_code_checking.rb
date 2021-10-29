# frozen_string_literal: true

module Operations::Me
  class ReferredCodeChecking < Trailblazer::Operation
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
      uri = URI("#{ENV['FIADOS_NODEJS_API_URL']}codeStatus")
      payload = { data: { code: params[:data][:code] } }.to_json

      response = Net::HTTP.post(uri, payload, 'Content-Type' => 'application/json')
      api_payload = JSON.parse(response.body)

      if response.code != '200'
        error!(
          status: 500,
          errors: {
            Api: "Request failed: #{api_payload['message']}"
          }
        )
      end

      options[:data] = api_payload['data']
    end

    def handle_response!(options, data:, params:, **)
      result =
        if data.nil? || data['renderLimit'].nil?
          false
        elsif params[:data][:userType].to_i.zero?
          true
        else
          data['renderLimit'].to_i >= data['renderCount'].to_i
        end

      options[:response] = { data: { result: result } }
    end
  end
end
