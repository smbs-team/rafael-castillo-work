# frozen_string_literal: true

# User's contacts
class Contact < ApplicationRecord
  belongs_to :device
end
