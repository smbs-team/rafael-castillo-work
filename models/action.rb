# frozen_string_literal: true

# Supported Actions
class Action < ApplicationRecord
  has_many :device_actions
  has_many :devices, through: :device_actions
end
