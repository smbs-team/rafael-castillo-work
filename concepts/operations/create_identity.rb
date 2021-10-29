# frozen_string_literal: true

module Operations
  # Create a new identity for the current user
  class CreateIdentity < Paw::Operations::Api::Form
    pass :inject_current_user!, before: :data!
    pass :get_user_data!, after: :validate!
    pass :validate_data!, after: :get_user_data!
    pass :validate_provider!, before: :persist!
    pass :set_internal_id!, after: :persist!

    private

    def inject_current_user!(_options, params:, current_user:, **)
      params['data']['user_id'] = current_user.id
    end

    def get_user_data!(options, params:, **)
      options[:user_data] = UserExternalData.obtain_data_from_provider(params[:data][:provider],
                                                                       params[:data][:auth_token])
    end

    def validate_provider!(_options, params:, **)
      record = Identity.find_by(user_id: params['data']['user_id'], provider: params[:data][:provider])
      return unless record

      Paw::Utils.error!(
        status: 400, message: "User has already linked his/her #{params[:data][:provider]} account"
      )
    end

    def validate_data!(options, user_data:, **)
      if user_data[:response].key?('error')
        Paw::Utils.error!(
          status: 400, message: 'Invalid Authorization Token'
        )
      end
      options[:internal_id] = user_data[:response]['id']
    end

    def set_internal_id!(_options, params:, internal_id:, **)
      record = Identity.find_by(user_id: params['data']['user_id'], provider: params[:data][:provider])
      record.update(internal_id: internal_id)
    end
  end
end
