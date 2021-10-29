# frozen_string_literal: true

module Queries
  module Me
    # Always pull the resources that the current user owns
    class CurrentUserDeviceActionsQuery < Paw::Queries::BaseQuery
      def call(current_user, device_id)
        query = relation.joins(device_actions: [device: :user]).where(
          condition,
          current_user, device_id
        )
        concat!(query)
      end

      def condition
        'users.id = ? AND devices.id = ?'
      end
    end
  end
end
