# frozen_string_literal: true

# Supported Segments
class Segment < ApplicationRecord
  has_many :users
end
