# frozen_string_literal: true

module Operations
  module Users
    # Operation to Send an Email for Activation
    class Activate < Trailblazer::Operation
      pass :activate_user!

      private

      def activate_user!(options, token:, **)
        user = User.load_from_activation_token(token)
        options[:activated] = true if user&.activate!
      end
    end
  end
end
