# frozen_string_literal: false

require 'pdf_manager'
require 'signature_generator'
require 'aws-sdk-s3'

module Operations
  # Operation to attach a signature to an array of documents
  class SignBureauOperation < Trailblazer::Operation
    delegate :error!, to: Paw::Utils
    pass :build_model!
    pass :contract!
    pass :validate!
    pass :check_signed_bureau!
    pass :create_legal_document!
    pass :save_signature!

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

    def check_signed_bureau!(_options, current_user:, **)
      return unless current_user.bureau_signed?

      error!(
        errors: { user: 'User has already signed the bureau' },
        status: 404
      )
    end

    def create_legal_document!(options, current_user:, **)
      document = current_user.legal_documents
                             .create!(kind: 'bureau',
                                      name: "Autorizacion de Bureau de #{current_user.name}")
      options[:document_id] = document.id
    end

    def save_signature!(_options, document_id:, current_user:, params:, **)
      s3 = Aws::S3::Client.new
      s3.put_object(bucket: ENV['AWS_BUCKET'], key: current_user.dui_number, body: params[:data][:signature])
      GenerateAndSignBureauJob.perform_later(document_id, current_user.dui_number, current_user.id)
    end
  end
end
