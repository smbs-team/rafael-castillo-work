# frozen_string_literal: true

# Stores user's location
class Location < ApplicationRecord
  belongs_to :device

  validates :lat, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :long, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
end
