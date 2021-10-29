# frozen_string_literal: true

module Operations
  # Operation to get prequalification for user
  class RequestLoanOperation < Trailblazer::Operation
    delegate :error!, to: Paw::Utils
    pass :build_model!
    pass :contract!
    pass :validate!
    pass :set_action!
    pass :obtain_data_from_api!
    pass :update_segment!
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

    def set_action!(options, **)
      options[:action] = 'loan'
    end

    def obtain_data_from_api!(options, current_user:, contract:, **)
      data = Operations::FiadosDataOperation.call(
        api: 'algorithm',
        url: ENV['FIADOS_URL'],
        action: options[:action],
        body_params: {
          "user_id": current_user.id,
          "amount_requested": contract.amount_requested,
          "installments": contract.installments
        }
      )
      response = data[:response]
      response.merge!("overdue_fee": ENV['OVERDUE_FEE'])
      options[:data] = OpenStruct.new(response)
    end

    def update_segment!(_options, data:, current_user:, **)
      segment = Segment.find_by(label: data['segment'])
      unless segment
        error!(
          errors: { segment: 'Segment not found' },
          status: 404
        )
      end

      current_user.update!(segment: segment)
    end

    def present!(options, data:, **)
      response = options[:presenter_class].new(data)

      options[:response] = {
        data: response.to_hash
      }
    end
  end
end
