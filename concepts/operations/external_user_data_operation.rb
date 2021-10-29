# frozen_string_literal: true

module Operations
  # Operation to Acquire user data from a third party Api
  class ExternalUserDataOperation < Trailblazer::Operation
    pass :get_data!
    pass :present!

    private

    def get_data!(options, token:, url:)
      uri = URI.parse("#{url}access_token=#{token}")
      response = Net::HTTP.get_response(uri)
      user_data = JSON.parse(response.body)
      options[:data] = user_data
    end

    def present!(options, data:, **)
      options[:response] = data.to_hash
    end
  end
end
