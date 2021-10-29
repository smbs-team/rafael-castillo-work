# frozen_string_literal: true

# User model
class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :legal_documents, as: :documentable
  has_many :addresses
  has_many :documents
  has_many :identities
  has_many :loans
  has_many :devices
  has_many :answers
  has_many :questions, through: :answers
  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken',
                           foreign_key: :resource_owner_id, dependent: :destroy

  belongs_to :segment, optional: true

  validates :email, uniqueness: true, if: -> { !email.blank? }
  validates :phone_number, uniqueness: true

  delegate :id, :label, to: :segment, prefix: true, allow_nil: true

  enum user_type: { person: 0, enterprise: 1 }

  def name
    "#{first_name} #{last_name}"
  end

  def dui_number
    documents&.where(kind: 'dui')&.first&.number
  end

  def nit_number
    documents&.where(kind: 'nit')&.first&.number
  end

  def city_and_street
    "#{city}, #{street}"
  end

  def city
    addresses&.first&.city
  end

  def street
    addresses&.first&.street
  end

  def state
    addresses&.first&.state
  end

  def last_loan
    loans&.last&.status
  end

  def age
    ((Time.zone.now - birth_date.to_time) / 1.year.seconds).floor
  end

  def bureau_signed?
    !!legal_documents.where(kind: 'bureau').first&.signed?
  end

  def access_contract_generated?
    legal_documents.access_contract.present?
  end
end
