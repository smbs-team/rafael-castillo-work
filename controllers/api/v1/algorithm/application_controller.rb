# frozen_string_literal: true

module Api
  module V1
    module Algorithm
      # /algorithm namespace specific
      class ApplicationController < Api::V1::ApplicationController
        include AlgorithmConcern

        before_action :skip_pagination, only: %i[index]
        before_action { doorkeeper_authorize! :api }

        private

        def skip_pagination
          params.merge!(page: { size: 0 })
        end
      end
    end
  end
end
