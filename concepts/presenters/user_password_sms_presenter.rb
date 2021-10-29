# frozen_string_literal: true

module Presenters
  # Serializer/presenter for UserSms model
  class UserPasswordSmsPresenter < Paw::Presenters::Api::BasePresenter
    # TODO: Look for a way to not use this presenter
    property :phone_number
  end
end
