# frozen_string_literal: true

# Street Address class
class Address < ApplicationRecord
  belongs_to :user
end
