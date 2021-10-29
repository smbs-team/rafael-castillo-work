# frozen_string_literal: true

# PuntoExpress locations
class PaymentLocation < ApplicationRecord
  reverse_geocoded_by :lat, :long
end
