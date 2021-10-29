# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for years of loan movements
    class LoanMovementsYearsPresenter < Paw::Presenters::Api::BasePresenter
      property :year
      collection :months, decorator: Presenters::Common::LoanMovementsMonthsPresenter
    end
  end
end
