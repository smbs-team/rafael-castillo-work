# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for Device model
    class DevicePresenter < Paw::Presenters::Api::BasePresenter
      property :id
      property :model_num
      property :imei
      property :uuid
      property :sms_last_sync_at
      property :contacts_last_sync_at
      property :onesignal_id
    end
  end
end
