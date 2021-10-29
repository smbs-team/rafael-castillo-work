# frozen_string_literal: true

# Generates payment and disbursment code
class ApiAuthenticatorService < ApplicationService
  delegate :error!, to: Paw::Utils

  API_KEYS = {
    algorithm: {
      client_id: ENV['FIADOS_CLIENT_ID'],
      client_secret: ENV['FIADOS_CLIENT_SECRET'],
      url: ENV['FIADOS_URL']
    },

    producer: {
      client_id: ENV['FIADOS_PRODUCER_CLIENT_ID'],
      client_secret: ENV['FIADOS_PRODUCER_CLIENT_SECRET'],
      url: ENV['FIADOS_PRODUCER_URL']
    }
  }.freeze

  def self.call(kind)
    new.call(kind)
  end

  def call(kind)
    Rails.cache.fetch("#{kind}-auth_token", expires_in: 2.hours) do
      uri = URI("#{API_KEYS[kind.to_sym][:url]}oauth/token")
      body_params = {
        client_id: API_KEYS[kind.to_sym][:client_id].to_s,
        client_secret: API_KEYS[kind.to_sym][:client_secret].to_s
      }

      response = JSON.parse(Net::HTTP.post_form(uri, body_params).body)

      response['error'] && error!(errors: { Api: 'Request failed' }, status: 500)
      response['access_token']
    end
  end
end
