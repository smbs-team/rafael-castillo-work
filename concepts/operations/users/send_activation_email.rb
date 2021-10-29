# frozen_string_literal: true

module Operations
  module Users
    # Operation to Send an Email for Confirmation
    class SendActivationEmail < Trailblazer::Operation
      delegate :error!, to: Paw::Utils
      pass :build_model!
      pass :contract!
      pass :validate!
      pass :send_email!
      pass :present!

      private

      def build_model!(options, **)
        options[:model] = OpenStruct.new
      end

      def contract!(options, model:, **)
        options[:contract] ||= options[:contract_class].new(model)
      end

      def validate!(options, params:, **)
        valid = options[:contract].validate(params[:data])
        return if valid

        error!(
          errors: options[:contract].errors,
          status: options[:error_status]
        )
      end

      def send_email!(_options, contract:, **)
        contract.sync
        user = User.find_by_email(contract.email)
        return unless user

        user.setup_activation
        user.save!
        UserMailer.activation_needed_email(user.email).deliver_later
      end

      def present!(options, model:, **)
        data = options[:presenter_class].new(model)

        options[:response] = {
          data: data.to_hash
        }
      end
    end
  end
end
