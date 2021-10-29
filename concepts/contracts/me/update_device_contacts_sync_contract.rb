# frozen_string_literal: true

module Contracts
  module Me
    # Update Device Contacts Sync Date Contract/Form Object
    class UpdateDeviceContactsSyncContract < Contracts::BaseContractPatched
      property :contacts_last_sync_at
    end
  end
end
