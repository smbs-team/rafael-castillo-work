# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for DeviceAction model
    class DeviceActionPresenter < Paw::Presenters::Api::BasePresenter
      property :device_id
      property :action_id
    end
  end
end
