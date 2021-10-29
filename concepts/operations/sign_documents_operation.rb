# frozen_string_literal: false

require 'pdf_manager'
require 'signature_generator'
require 'aws-sdk-s3'

module Operations
  # Operation to attach a signature to an array of documents
  class SignDocumentsOperation < Trailblazer::Operation
    delegate :error!, to: Paw::Utils
    pass :build_model!
    pass :contract!
    pass :validate!
    pass :obtain_documents!
    pass :save_signature!
    pass :add_disbursement_code!

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

    def obtain_documents!(options, params:, current_user:, **)
      signature_key = current_user.dui_number
      params[:data][:documents_ids].each do |id|
        LegalDocument.find id
        signature_key << id
      end
      options[:signature_key] = signature_key
    end

    def save_signature!(_options, params:, signature_key:, **)
      Aws::S3::Client.new.put_object(
        bucket: ENV['AWS_BUCKET'],
        key: signature_key,
        body: params[:data][:signature]
      )
      SignDocumentsJob.perform_later(params[:data][:documents_ids], signature_key)
    end

    def add_disbursement_code!(_options, current_user:, **)
      if (loan = Queries::Me::ObtainCrowdfundedLoanQuery.new(Loan).call(current_user.id))
        movement = loan.withdrawals.select { |withdrawal| withdrawal.status == 'in_progress' }
        movement.first.update!(disbursement_code: CodeGeneratorService.call)
        movement.first.state_to(:ready)
      end
    end
  end
end
