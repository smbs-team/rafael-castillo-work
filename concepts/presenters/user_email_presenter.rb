# frozen_string_literal: true

module Presenters
  # Serializer/presenter for UserEmail model
  class UserEmailPresenter < Paw::Presenters::Api::BasePresenter
    property :email
  end
end
