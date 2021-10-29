# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for Prequalify request
    class PrequalifyPresenter < Paw::Presenters::Api::BasePresenter
      property :segment
      property :segment_id
      property :user_id
      property :min_amount
      property :max_amount
      property :min_installments
      property :max_installments
      property :approved
    end
  end
end
