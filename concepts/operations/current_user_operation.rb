# frozen_string_literal: true

module Operations
  # add current user attr to model
  class CurrentUserOperation < Paw::Operations::Api::Form
    pass :inject_current_user!, before: :data!

    private

    def inject_current_user!(_options, params:, current_user:, **)
      params['data']['user_id'] = current_user.id
    end
  end
end
