# frozen_string_literal: true

module Api
  module V1
    module Me
      # Personal Documents Controller
      class PersonalDocumentsController < Api::V1::Me::ApplicationController
        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/personal_documents',
          method: 'get',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List of user documents',
          tags: [
            'api/v1/me/personal_documents'
          ],
          success_status: 200,
          error_responses: [400, 401, 422, 500],
          presenter: Presenters::Me::PersonalDocumentPresenter
        )

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/personal_documents',
          method: 'post',
          summary: 'Creates a document for the current user',
          tags: [
            'api/v1/me/personal_documents'
          ],
          success_status: 201,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::PersonalDocumentPresenter,
          contract: Contracts::Me::PersonalDocumentContract
        )

        def create
          response = Operations::CreatePersonalDocumentOperation.call(
            form_options
          )
          render json: response[:response], status: 201
        end

        private

        def fetch_options
          {
            params: params.merge!(page: { size: 0 }),
            model_class: Document,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Me::PersonalDocumentPresenter,
            default_scope: lambda { |query|
              Queries::Commons::CurrentUserQuery.new(query).call(current_user.id)
            }
          }
        end

        def form_options
          {
            params: params,
            current_user: current_user,
            model_class: Document,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            contract_class: Contracts::Me::PersonalDocumentContract,
            presenter_class: Presenters::Me::PersonalDocumentPresenter
          }
        end
      end
    end
  end
end
