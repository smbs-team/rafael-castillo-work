# frozen_string_literal: true

module Queries
  # Gets payment locations near coordinates
  class PaymentLocationsQuery < Paw::Queries::BaseQuery
    def call(lat, long)
      query = relation.near(
        [lat, long], ENV['LOCATION_SEARCH_RADIUS']
      )
      concat!(query) if lat.present? && long.present?
    end
  end
end
