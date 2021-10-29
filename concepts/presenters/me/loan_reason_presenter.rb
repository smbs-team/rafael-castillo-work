# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for LoanReason model
    class LoanReasonPresenter < Paw::Presenters::Api::BasePresenter
      property :reason_id
    end
  end
end
