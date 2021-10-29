# frozen_string_literal:true

# Users' sms
class Sms < ApplicationRecord
  belongs_to :device

  validates_uniqueness_of :message_internal_id, scope: [:device_id]
end
