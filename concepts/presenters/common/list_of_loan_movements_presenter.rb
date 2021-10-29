# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for list of loan movements
    class ListOfLoanMovementsPresenter < Paw::Presenters::Api::BasePresenter
      collection :years, decorator: Presenters::Common::LoanMovementsYearsPresenter
    end
  end
end
