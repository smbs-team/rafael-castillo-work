# frozen_string_literal: true

# User's devices
class Device < ApplicationRecord
  has_many :device_actions
  has_many :actions, through: :device_actions
  has_many :sms
  has_many :contacts
  has_many :locations
  belongs_to :user

  validates_uniqueness_of :uuid, scope: [:user_id]
  validates_uniqueness_of :imei, scope: [:user_id]

  before_create :set_as_most_recent
  before_update :set_as_most_recent,
                if: proc { |device| device.sms_last_sync_at_changed? || device.contacts_last_sync_at_changed? }

  private

  def set_as_most_recent
    old_device = Device.find_by(user_id: user_id, most_recent: true)
    old_device.update!(most_recent: false) if old_device && old_device.id != id
    self.most_recent = true
  end
end
