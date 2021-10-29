# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for Contact model
    class ContactPresenter < Paw::Presenters::Api::BasePresenter
      property :username
      property :phone_number
    end
  end
end
