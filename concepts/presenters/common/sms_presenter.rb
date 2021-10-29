# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for Sms model
    class SmsPresenter < Paw::Presenters::Api::BasePresenter
      property :message
      property :sender
      property :read_state
      property :time
      property :folder
      property :message_internal_id
    end
  end
end
