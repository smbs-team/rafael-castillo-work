# frozen_string_literal: true

module Contracts
  module Me
    # Update Device SMS Sync Date Contract/Form Object
    class UpdateDeviceMessageSyncContract < Contracts::BaseContractPatched
      property :sms_last_sync_at
    end
  end
end
