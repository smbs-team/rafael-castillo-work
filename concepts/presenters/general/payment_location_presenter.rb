# frozen_string_literal: true

module Presenters
  module General
    # Serializer/presenter for Location model
    class PaymentLocationPresenter < Paw::Presenters::Api::BasePresenter
      property :name
      property :distance
      property :address
      property :lat
      property :long
    end
  end
end
