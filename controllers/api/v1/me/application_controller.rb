# frozen_string_literal: true

module Api
  module V1
    module Me
      # /me namespace specific
      class ApplicationController < Api::V1::ApplicationController
        include CurrentUserConcern
        before_action do
          doorkeeper_authorize! :user
        end
      end
    end
  end
end
