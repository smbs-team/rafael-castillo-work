# frozen_string_literal: true

module Presenters
  module Mts
    # Serializer/presenter for Withdrawals
    class WithdrawalPresenter < Presenters::Mts::TransactionPresenter
      property :disbursement_code, as: :code, render_nil: false
    end
  end
end
