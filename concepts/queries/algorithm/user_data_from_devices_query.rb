# frozen_string_literal: true

module Queries
  module Algorithm
    # Always pull the resources linked to the user device
    class UserDataFromDevicesQuery < Paw::Queries::BaseQuery
      def call(value)
        query = relation.joins(device: :user).where(condition, value)
        concat!(query)
      end

      def condition
        'users.id = ?'
      end
    end
  end
end
