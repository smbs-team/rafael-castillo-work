# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for Identity model
    class IdentityPresenter < Paw::Presenters::Api::BasePresenter
      property :provider
      property :auth_token
    end
  end
end
