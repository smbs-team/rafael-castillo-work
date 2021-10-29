# frozen_string_literal: true

module Presenters
  # Serializer/presenter for UserSms model
  class UserSMSPresenter < Paw::Presenters::Api::BasePresenter
    property :phone_number
    property :verification_code
  end
end
