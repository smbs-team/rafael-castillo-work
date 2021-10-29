# frozen_string_literal: true

module Budget
  class PhoneExpenses
    attr_reader :user_id, :date

    def initialize(user_id:, date:)
      @user_id = user_id
      @date = date
    end

    def sum
      to_a.sum
    end

    def to_a
      data.map { |item| BigDecimal(item['amount']) }
    end

    private

    def data
      @data ||= PhoneExpensesQuery.call(user_id: user_id, date: date)
    end
  end
end
