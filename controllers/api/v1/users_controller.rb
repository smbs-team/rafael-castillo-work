# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApplicationController # rubocop:disable Metrics/ClassLength
      skip_before_action :require_data!, only: %i[confirm_email me create_with_provider budget]
      before_action :require_provider_data!, only: %i[create_with_provider]
      before_action only: %i[me index update change_password budget] do
        doorkeeper_authorize! :user
      end

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/users',
        method: 'post',
        summary: 'Create a user',
        tags: [
          'api/v1/users'
        ],
        success_status: 201,
        error_responses: [401, 422, 500],
        presenter: Presenters::Common::UserPresenter,
        contract: Contracts::UserContract
      )

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/users/send_activation_email',
        method: 'post',
        summary: 'Sends a confirmation email to a users',
        tags: [
          'api/v1/users'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::UserEmailPresenter,
        contract: Contracts::UserEmailContract
      )

      def send_activation_email
        response = Operations::Users::SendActivationEmail.call(
          form_options_for_send_activation_email
        )
        render json: response[:response], status: response[:status]
      end

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/users/send_verification_sms',
        method: 'post',
        summary: 'Sends an sms with a verification number',
        tags: [
          'api/v1/users'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::UserSMSPresenter,
        contract: Contracts::UserPhoneContract
      )

      def send_verification_sms
        response = Operations::Users::SendVerificationSMS.call(
          form_options_for_send_verification_sms
        )
        render json: response[:response], status: response[:status]
      end

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/users/send_forgot_password_sms',
        method: 'post',
        summary: 'Sends an sms with a randomly generated password',
        tags: [
          'api/v1/users'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::EmptyPresenter,
        contract: Contracts::UserPasswordSmsContract
      )

      def send_forgot_password_sms
        Operations::Users::SendForgotPasswordSms.call(
          form_options_for_forgot_password_sms
        )
      end

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/me',
        method: 'get',
        collection: false,
        allowed_includes: allowed_includes,
        allowed_sorts: allowed_sorts,
        summary: 'Shows current user details',
        tags: [
          'api/v1/me'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::Common::UserPresenter
      )

      def me
        response = Paw::Operations::Api::Finder.call(
          fetch_options.merge!(collection: false)
        )
        render json: response[:response]
      end

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/me',
        method: 'patch',
        collection: true,
        allowed_includes: allowed_includes,
        allowed_sorts: allowed_sorts,
        summary: 'Update current user details',
        tags: [
          'api/v1/me'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::Common::UserPresenter,
        contract: Contracts::UpdateUserContract
      )

      def update
        response = Paw::Operations::Api::Form.call(
          form_options_for_update
        )
        render json: response[:response]
      end

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/me/change_password',
        method: 'patch',
        collection: true,
        allowed_includes: allowed_includes,
        allowed_sorts: allowed_sorts,
        summary: 'Update/change current user password',
        tags: [
          'api/v1/me'
        ],
        success_status: 204,
        error_responses: [401, 422, 500],
        presenter: Presenters::EmptyPresenter,
        contract: Contracts::Me::ChangePassword
      )

      def change_password
        response = Operations::Me::ChangePasswordOperation.call(
          form_options_for_change_password
        )
        render json: response[:response], status: 204
      end

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/users/create_with_provider',
        method: 'post',
        collection: true,
        allowed_includes: allowed_includes,
        allowed_sorts: allowed_sorts,
        summary: "Create user using a provider's token",
        tags: [
          'api/v1/users'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::Common::UserPresenter,
        contract: Contracts::UserWithProviderContractForDoc
      )

      def create_with_provider
        response = Operations::Users::CreateWithProvider.call(
          form_options_for_provider
        )
        render json: response[:response], status: 201
      end

      Paw::SwaggerDoc.endpoint(
        path: '/api/v1/users/:id/budget',
        method: 'get',
        collection: false,
        summary: 'Shows the expenses for specified month',
        tags: [
          'api/v1/users'
        ],
        success_status: 200,
        error_responses: [401, 422, 500],
        presenter: Presenters::Common::UserPresenter
      )

      def budget
        response = Operations::Users::Budget.call(budget_options)
        render json: response[:response]
      end

      private

      def form_options_for_update
        {
          params: params.merge(id: current_user.id),
          model_class: User,
          contract_class: Contracts::UpdateUserContract,
          presenter_class: Presenters::Common::UserPresenter
        }
      end

      def form_options_for_change_password
        {
          params: params,
          current_user: current_user,
          model_class: User,
          contract_class: Contracts::Me::ChangePassword,
          presenter_class: Presenters::Common::UserPresenter
        }
      end

      def form_options_for_send_activation_email
        {
          params: params,
          contract_class: Contracts::UserEmailContract,
          presenter_class: Presenters::UserEmailPresenter
        }
      end

      def form_options_for_send_verification_sms
        {
          params: params,
          contract_class: Contracts::UserPhoneContract,
          presenter_class: Presenters::UserSMSPresenter
        }
      end

      def form_options_for_forgot_password_sms
        {
          params: params,
          model_class: User,
          contract_class: Contracts::UserPasswordSmsContract,
          presenter_class: Presenters::UserPasswordSmsPresenter
        }
      end

      def form_options
        {
          params: params,
          model_class: User,
          allowed_includes: self.class.allowed_includes,
          allowed_sorts: self.class.allowed_sorts,
          contract_class: Contracts::UserContract,
          presenter_class: Presenters::Common::UserPresenter
        }
      end

      def form_options_for_provider
        {
          params: params.merge!(action: 'create'),
          token: params['data']['token'],
          provider: params['data']['provider'],
          model_class: User,
          allowed_includes: self.class.allowed_includes,
          allowed_sorts: self.class.allowed_sorts,
          contract_class: Contracts::UserWithProviderContract,
          presenter_class: Presenters::Common::UserPresenter
        }
      end

      def fetch_options
        {
          params: params.merge(id: current_user.id, page: { size: 0 }),
          model_class: User,
          allowed_includes: self.class.allowed_includes,
          allowed_sorts: self.class.allowed_sorts,
          presenter_class: Presenters::Common::UserPresenter
        }
      end

      def require_provider_data!
        return unless params['data']['provider'].blank? || params['data']['token'].blank?

        e = Paw::Exceptions::StandardError.new(
          message: 'Provider and Token are required paramethers and can not be empty',
          status: 400,
          code: 400
        )
        raise e
      end

      def budget_options
        {
          params: params,
          contract_class: nil,
          presenter_class: nil
        }
      end
    end
  end
end
