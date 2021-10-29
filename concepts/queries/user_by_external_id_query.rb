# frozen_string_literal: true

module Queries
  # Obtains user data by it's internal id given a provider
  class UserByExternalIdQuery < Paw::Queries::BaseQuery
    def call(id, provider)
      query = relation.joins(:identities).where(
        condition,
        id, provider
      )
      concat!(query)
    end

    def condition
      'identities.internal_id = ? AND identities.provider = ?'
    end
  end
end
