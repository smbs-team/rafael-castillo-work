# frozen_string_literal: true

# 3rd Party Identities
class Identity < ApplicationRecord
  belongs_to :user

  validates :provider, :auth_token, presence: true
end
