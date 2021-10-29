# frozen_string_literal: true

module Operations
  module Users
    # Operation to Send an Email for Confirmation
    class SendVerificationSMS < Trailblazer::Operation
      delegate :error!, to: Paw::Utils
      pass :build_model!
      pass :contract!
      pass :validate!
      pass :send_sms!
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

      def send_sms!(_options, contract:, model:, **)
        contract.sync
        verification_code = rand.to_s[2..5]
        SendVerificationSMSJob.perform_later(
          "+503#{contract.phone_number}",
          verification_code
        )
        model.verification_code = verification_code
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
