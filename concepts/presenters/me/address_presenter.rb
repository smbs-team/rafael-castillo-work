# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for Address model
    class AddressPresenter < Paw::Presenters::Api::BasePresenter
      property :city
      property :state
      property :zip_code
      property :street
      property :country
    end
  end
end
