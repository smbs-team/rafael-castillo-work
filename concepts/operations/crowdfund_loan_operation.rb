# frozen_string_literal: true

module Operations
  # Operation to create mutuos for user
  class CrowdfundLoanOperation < Trailblazer::Operation
    delegate :error!, to: Paw::Utils
    pass :build_model!
    pass :contract!
    pass :validate!
    pass :fetch_confirmed_loan!
    pass :generate_mutuos!
    pass :generate_access_contract!
    pass :present!

    private

    def build_model!(options, params:, **)
      options[:model] = JSON.parse(params[:data].to_json, object_class: OpenStruct)
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

    def fetch_confirmed_loan!(options, params:, **)
      options[:loan] = Loan.where(user_id: params[:user_id]).in_state(:confirmed).first
      return if options[:loan].present?

      error!(
        errors: { loan: 'confirmed Loan not found' },
        status: 404
      )
    end

    def generate_mutuos!(options, params:, **)
      producers = params[:data][:producers]
      producers_array = []
      options[:mutuos] = []
      producers.each do |producer|
        producers_array << producer.to_unsafe_h
        options[:mutuos] << { producer_name: producer[:first_name] }
      end
      GenerateMutuosJob.perform_later(producers_array, options[:loan].id)
    end

    def generate_access_contract!(_options, params:, **)
      user = User.find(params[:user_id])
      GenerateAccessContractJob.perform_later(user.id) unless user.access_contract_generated?
    end

    def present!(options, mutuos:, **)
      options[:response] = {
        data: mutuos
      }
    end
  end
end
