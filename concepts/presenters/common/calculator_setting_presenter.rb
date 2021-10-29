# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for CalculatorSetting model
    class CalculatorSettingPresenter < Paw::Presenters::Api::BasePresenter
      property :max_terms
      property :min_terms
      property :max_amount
      property :min_amount
      property :interest_rate
      property :default_amount
      property :default_terms
      property :id
    end
  end
end
