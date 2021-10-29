# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for Update Device Sms Sync Date request
    class UpdateDeviceMessageSyncPresenter < Paw::Presenters::Api::BasePresenter
      property :sms_last_sync_at
    end
  end
end
