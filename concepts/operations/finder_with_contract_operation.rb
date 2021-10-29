# frozen_string_literal: true

module Operations
  # Operation to require query params
  class FinderWithContractOperation < Paw::Operations::Api::Finder
    pass :contract_class!, before: :filter!
    pass :build_model!, after: :contract_class!
    pass :contract!, after: :build_model!
    pass :validate!, after: :contract!

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
  end
end
