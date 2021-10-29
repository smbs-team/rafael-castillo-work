# frozen_string_literal: true

require 'user_external_data'

module Operations
  module Users
    # Operation to Send an Email for Confirmation
    class CreateWithProvider < Paw::Operations::Api::Form
      delegate :error!, to: Paw::Utils
      pass :get_user_data!, after: :validate!
      pass :validate_data!, after: :get_user_data!
      pass :check_identity!, before: :persist!
      pass :create_identity!, after: :persist!

      private

      def get_user_data!(options, **)
        options[:user_data] = UserExternalData.obtain_data_from_provider(options[:provider], options[:token])
      end

      def validate_data!(options, user_data:, **)
        if user_data[:response].key?('error')
          error!(
            status: 400, message: 'Invalid Provider Token'
          )
        end
        options[:internal_id] = user_data[:response]['id']
      end

      def check_identity!(_options, provider:, internal_id:, **)
        return unless Identity.find_by(internal_id: internal_id, provider: provider)

        error!(
          status: 400, message: "This #{provider} account has already been registered"
        )
      end

      def create_identity!(options, internal_id:, provider:, token:, **)
        options[:model].identities.create!(provider: provider, auth_token: token, internal_id: internal_id)
      end
    end
  end
end
