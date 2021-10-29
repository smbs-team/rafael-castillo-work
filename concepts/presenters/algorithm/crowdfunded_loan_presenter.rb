# frozen_string_literal: true

module Presenters
  module Algorithm
    # Serializer/presenter for Loan model
    class CrowdfundedLoanPresenter < Paw::Presenters::Api::BasePresenter
      property :producer_name
    end
  end
end
