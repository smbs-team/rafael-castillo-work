# frozen_string_literal: true

module Presenters
  module Mts
    # Serializer/presenter for TransactionDocument
    class IouDocumentPresenter < Paw::Presenters::Api::BasePresenter
      property :user_name
      property :user_dui_number
      property :user_nit_number
      property :user_trade
      property :loan_amount
      property :loan_interest_rate
      property :loan_interest_rate_letters, exec_context: :decorator
      property :loan_installments
      property :user_address
      property :day
      property :month
      property :year
      property :user_age

      def loan_interest_rate_letters
        decimal_reader(represented.loan_interest_rate)
      end

      def decimal_reader(number)
        amounts = format('%<number>.2f', number: number).split('.')
        "#{amounts.first.to_i.humanize} punto #{amounts.second.to_i.humanize}"
      end
    end
  end
end
