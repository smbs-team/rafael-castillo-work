# frozen_string_literal: true

module Operations
  # Operation for Algorithm's endpoints
  class AlgorithmFinderOperation < Paw::Operations::Api::Finder
    delegate :error!, to: Paw::Utils
    pass :check_data!, after: :params!

    private

    def check_data!(_options, params:, **)
      return if User.find_by(id: params[:user_id])

      error!(
        errors: { user_id: 'User not found' },
        status: 404
      )
    end
  end
end
