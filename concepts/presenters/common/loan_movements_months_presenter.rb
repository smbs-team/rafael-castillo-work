# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for months of loan movements
    class LoanMovementsMonthsPresenter < Paw::Presenters::Api::BasePresenter
      property :month
      property :past_due, render_nil: false
      collection :transactions, decorator: Presenters::Common::LoanMovementPresenter
    end
  end
end
