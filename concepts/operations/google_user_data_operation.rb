# frozen_string_literal: true

require 'google/apis/oauth2_v1'

module Operations
  # Operation to Acquire user data from google
  class GoogleUserDataOperation < Trailblazer::Operation
    pass :validate_token_id!
    pass :obtain_user_id!

    private

    def validate_token_id!(options, token:, **)
      validator = GoogleIDToken::Validator.new
      payload = validator.check(token, ENV['GOOGLE_CLIENT_ID'])
      options[:payload] = payload
    end

    def obtain_user_id!(options, payload:, **)
      options[:response] = payload.to_hash
    end
  end
end
