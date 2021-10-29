# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for Request Loan endpoint
    class RequestLoanPresenter < Paw::Presenters::Api::BasePresenter
      property :max_amount
      property :max_installments
      property :monthly_interest
      property :approved
      property :segment
      property :installment_amount
      property :disbursement_commision
      property :subscription_fee
      property :overdue_fee
    end
  end
end
