# frozen_string_literal: true

module Api
  module V1
    module Mts
      # Mts namespace specific
      class ApplicationController < Api::V1::ApplicationController
        include MtsConcern

        before_action do
          doorkeeper_authorize! :mts
        end

        def data
          params['data']
        end
      end
    end
  end
end
