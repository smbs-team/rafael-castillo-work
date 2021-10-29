# frozen_string_literal: true

module Budget
  class PhoneExpensesQuery
    def self.call(user_id:, date:)
      query = new(user_id: user_id, date: date)
      ActiveRecord::Base.connection.execute(query.sql).to_a
    end

    def initialize(user_id:, date:)
      @user_id = user_id
      @date = date
    end

    def sql
      @sql ||= <<-SQL
        SELECT
          substring(a.message, '\\d+[.]\\d+') amount,
          a.time, a.device_id, c.id user_id, a.message
        FROM sms a, devices b, users c
        WHERE
          a.device_id = b.id
          and b.user_id = c.id
          and c.id = #{ActiveRecord::Base.connection.quote(@user_id)}
          --PARAMETERS: MONTH AND YEAR
          and date_trunc('month',time) = TO_DATE((CAST(#{month} as text)) || '-' || (CAST(#{year} as text)), 'MM-YYYY')
          and (message like '%Tigo informa: su factura de servicio(s)%'
            or message like '%Tu factura Tigo es por%'
            or message like '%Movistar te informa que tu factura vto%'
          )
        UNION
        SELECT
          substring(SUBSTRING(a.message,POSITION('Tu nuevo monto' in a.message)), '\\d+[.]\\d+') amount,
          a.time, a.device_id, c.id user_id, a.message
        FROM sms a, devices b, users c
        WHERE
          a.device_id = b.id
          and b.user_id = c.id
          and c.id = #{ActiveRecord::Base.connection.quote(@user_id)}
          --PARAMETERS: MONTH AND YEAR
          and date_trunc('month',time) = TO_DATE((CAST(#{month} as text)) || '-' || (CAST(#{year} as text)), 'MM-YYYY') --CURRENT MONTH
          and a.message like '%Gracias x usar Tigo Te Presta. Se desconto un total%'
      SQL
    end

    def month
      @date.month
    end

    def year
      @date.year
    end
  end
end
