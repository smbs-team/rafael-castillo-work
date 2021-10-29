# frozen_string_literal: true

module Operations
  module Transactions
    # Operation to Complete a Withdrawal by its Transaction Code
    class CompleteWithdrawalOperation < Trailblazer::Operation
      delegate :error!, to: Paw::Utils
      pass :contract_class!
      pass :build_model!
      pass :contract!
      pass :validate!
      pass :obtain_withdrawal!
      pass :transaction!
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
        withdrawal = Queries::Mts::PendingWithdrawalQuery.new(Withdrawal)
                                                         .call(contract.user_dui_number, contract.code)

        if withdrawal.empty?
          error!(
            message: "Document number doesn't match transaction code.",
            status: 422
          )
        end

        options[:withdrawal] = withdrawal.first
      end

      def transaction!(_options, withdrawal:, contract:, **)
        ActiveRecord::Base.transaction do
          withdrawal.state_machine.transition_to!(:complete)
          withdrawal.update!(disbursement_code: nil, code: contract.reference_code, completed_at: DateTime.current)
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
