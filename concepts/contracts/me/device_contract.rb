# frozen_string_literal: true

module Contracts
  module Me
    # Device Contract/Form Object
    class DeviceContract < Contracts::BaseContractPatched
      property :model_num
      property :imei
      property :uuid
      property :user_id
      property :onesignal_id
      validates :uuid, presence: true, if: -> { imei.blank? }
      validates :imei, presence: true, if: -> { uuid.blank? }
    end
  end
end
