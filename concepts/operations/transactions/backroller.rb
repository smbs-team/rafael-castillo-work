# frozen_string_literal: true

module Operations
  module Transactions
    # Operation to Backroll a Loan by its Transaction Code
    class Backroller < Trailblazer::Operation
      delegate :error!, to: Paw::Utils
      pass :contract_class!
      pass :build_model!
      pass :contract!
      pass :validate!
      pass :obtain_withdrawal!
      pass :check_movement!
      pass :persist!
      pass :present!

      private

      def contract_class!(options, **)
        contract_class = options[:contract_class]
        unless contract_class.is_a?(Class) && contract_class.ancestors
                                                            .include?(
                                                              Reform::Form
                                                            )
          raise ArgumentError,
                'Supply a valid contract_class option'
        end
      end

      def build_model!(options, params:, **)
        options[:contract_data] = JSON.parse(params[:data].to_json, object_class: OpenStruct)
      end

      def contract!(options, **)
        options[:contract] ||= options[:contract_class].new(options[:contract_data])
      end

      def validate!(options, params:, **)
        valid = options[:contract].validate(params[:data])
        return if valid

        error!(
          errors: options[:contract].errors,
          status: options[:error_status]
        )
      end

      def obtain_withdrawal!(options, contract:, **)
        withdrawal = Withdrawal.find_by(code: contract.code)

        unless withdrawal
          error!(
            message: "Referal number doesn't match any transaction.",
            status: 422
          )
        end

        unless withdrawal.loan.user.dui_number == contract.user_dui_number
          error!(
            message: "Dui number doesn't match user's number.",
            status: 422
          )
        end

        options[:withdrawal] = withdrawal
      end

      def check_movement!(_options, withdrawal:, **)
        valid = ['complete'].include? withdrawal.status

        unless valid
          error!(
            message: 'Transaction current status is not valid for this operation.',
            status: 422
          )
        end
        payments = withdrawal.loan.payments

        return if payments.empty?

        error!(
          message: 'Cannot rollback this transacction: first payment has been completed.',
          status: 422
        )
      end

      def persist!(_options, withdrawal:, **)
        ActiveRecord::Base.transaction do
          withdrawal.state_to(:backrolled)
          new_withdrawal = withdrawal.loan
                                     .withdrawals
                                     .create!(withdrawal.attributes
                                                        .except('id', 'created_at', 'updated_at', 'code'))
          new_withdrawal.update!(disbursement_code: CodeGeneratorService.call)
          new_withdrawal.state_to(:ready)
        end
      end

      def present!(options, withdrawal:, **)
        data = options[:presenter_class].new(withdrawal)

        options[:response] = {
          data: data.to_hash
        }
      end
    end
  end
end
