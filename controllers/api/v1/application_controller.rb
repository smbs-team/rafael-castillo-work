# frozen_string_literal: true

module Api
  module V1
    # Api::V1::Controller
    class ApplicationController < ActionController::API
      include Paw::Concerns::Controllers::ErrorHandlersConcern
      include Paw::Concerns::Controllers::CrudConcern

      class_attribute :allowed_includes, :allowed_sorts

      self.allowed_includes = []
      self.allowed_sorts = []

      before_action :require_data!, except: %i[index show destroy]

      private

      def current_user
        @current_user ||= User.find_by_id(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
