# frozen_string_literal: true

module Operations
  # Operation to return a single object without identifier
  class  ShowWithdrawalOperation < Operations::SingleItemWithContractOperation
    pass :set_iou_document!, after: :present!

    private

    def set_iou_document!(options, **)
      iou_document = OpenStruct.new(user_name: options[:model].user_name,
                                    user_dui_number: options[:model].user_dui_number,
                                    user_nit_number: options[:model].user_nit_number,
                                    loan_amount: options[:model].loan.initial_amount,
                                    loan_interest_rate: options[:model].loan.current_interest_rate,
                                    loan_installments: options[:model].loan.total_installments,
                                    user_address: options[:model].loan.user.addresses&.last&.state,
                                    user_trade: options[:model].loan.user.trade,
                                    user_age: options[:model].user_age,
                                    day: Date.current.in_time_zone.day,
                                    month: Date.current.in_time_zone.month,
                                    year: Date.current.in_time_zone.year)
      options[:response][:data][:iou_document] = Presenters::Mts::IouDocumentPresenter.new(iou_document)
    end
  end
end
