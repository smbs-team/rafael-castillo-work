# frozen_string_literal: true

module Operations
  # Add device id to params
  class CurrentDeviceOperation < Paw::Operations::Api::Form
    pass :inject_current_device!, before: :find_model!

    private

    def inject_current_device!(_options, params:, device_id:, **)
      params[:id] = device_id
    end
  end
end
