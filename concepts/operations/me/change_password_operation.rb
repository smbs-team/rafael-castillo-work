# frozen_string_literal: true

module Operations
  module Me
    # changes a user password
    class ChangePasswordOperation < Trailblazer::Operation
      delegate :error!, to: Paw::Utils
      pass :validate_current_password!
      pass :change_user_password!
      pass :change_force_reset_password!
      pass :present!

      private

      def validate_current_password!(_options, current_user:, params:, **)
        return if current_user.valid_password?(params[:data][:current_password])

        error!(
          errors: { user: 'current_password doesnt match' },
          status: '422'
        )
      end

      def change_user_password!(_options, current_user:, params:, **)
        current_user.update!(password: params['data']['new_password'])
      end

      def change_force_reset_password!(_options, current_user:, **)
        current_user.update!(force_reset_password: false) if current_user.force_reset_password
      end

      def present!(options, **)
        options[:response] = {
          data: []
        }
      end
    end
  end
end
