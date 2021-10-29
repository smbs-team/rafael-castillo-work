# frozen_string_literal: true

module Operations
  module Users
    # Operation to Send new password by SMS
    class SendForgotPasswordSms < Operations::FinderWithContractOperation
      delegate :error!, to: Paw::Utils
      pass :fetch_user_with_documents!, after: :validate!
      pass :set_force_reset_password!, after: :fetch_user_with_documents!
      pass :send_sms!, after: :set_force_reset_password!

      private

      def fetch_user_with_documents!(options, params:, **)
        options[:user] = User.joins(:documents)
                             .where(users: { phone_number: params[:data][:phone_number] },
                                    documents: { number: params[:data][:dui], kind: 'dui' }).first
        return if options[:user].present?

        error!(
          errors: { user: 'user not found' },
          status: 404
        )
      end

      def send_sms!(_options, contract:, user:, **)
        new_password = generate_new_password
        user.update!(password: new_password)
        SendForgotPasswordSmsJob.perform_now(
          "+503#{contract.phone_number}",
          new_password
        )
      end

      def set_force_reset_password!(_options, user:, **)
        user.force_reset_password = true
      end

      def present!(options, **)
        options[:response] = {
          data: []
        }
      end

      def generate_new_password
        ('A'..'Z').to_a.sample + SecureRandom.hex(3) + ['!', '?', '&'].sample
      end
    end
  end
end
