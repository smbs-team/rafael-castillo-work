# frozen_string_literal: true

module Queries
  module Me
    # Always pull the resources that the current user owns
    class UserDevicesQuery < Paw::Queries::BaseQuery
      def call(value1, value2, value3)
        query = relation.where(
          condition,
          value1, value2, value3
        )
        concat!(query)
      end

      def condition
        "(#{relation.table_name}.user_id = ? AND (#{relation.table_name}.imei = ? OR #{relation.table_name}.uuid = ?))"
      end
    end
  end
end
