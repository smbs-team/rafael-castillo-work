# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for Location model
    class LocationPresenter < Paw::Presenters::Api::BasePresenter
      property :lat
      property :long
      property :created_at
    end
  end
end
