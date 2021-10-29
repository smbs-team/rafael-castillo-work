# frozen_string_literal: true

# Actions taken per device
class DeviceAction < ApplicationRecord
  belongs_to :action
  belongs_to :device

  validates_uniqueness_of :device_id, scope: [:action_id]
end
