# frozen_string_literal: true

module Api
  module V1
    module Me
      # LegalDocument Controller
      class LegalDocumentsController < Api::V1::Me::ApplicationController
        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/loans/legal_documents',
          method: 'get',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'List of legal documents of the current crowdfunded loan',
          tags: [
            'api/v1/me/loans'
          ],
          success_status: 200,
          error_responses: [401, 422, 500],
          presenter: Presenters::Me::LegalDocumentsPresenter
        )

        def index
          response = Operations::Me::LoanLegalDocumentsList.call(fetch_options)
          render json: response[:response], status: response[:status]
        end

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/loans/legal_documents/sign',
          method: 'post',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: 'Sign legal document',
          tags: [
            'api/v1/me/loans'
          ],
          success_status: 204,
          error_responses: [401, 422, 500],
          contract: Contracts::Me::SignDocumentContract,
          presenter: Presenters::EmptyPresenter
        )

        def sign
          response = Operations::SignDocumentsOperation.call(
            sign_documents_operations
          )
          render json: response[:response], status: response[:status]
        end

        Paw::SwaggerDoc.endpoint(
          path: '/api/v1/me/legal_documents/sign_bureau',
          method: 'post',
          collection: true,
          allowed_includes: allowed_includes,
          allowed_sorts: allowed_sorts,
          summary: "Sign the credit's bureau",
          tags: [
            'api/v1/me/legal_documents'
          ],
          success_status: 204,
          error_responses: [401, 422, 500],
          contract: Contracts::Me::SignBureauContract,
          presenter: Presenters::EmptyPresenter
        )

        def sign_bureau
          Operations::SignBureauOperation.call(
            sign_bureau_operations
          )
        end

        private

        def sign_documents_operations
          {
            current_user: current_user,
            params: params,
            contract_class: Contracts::Me::SignDocumentContract,
            presenter_class: Presenters::EmptyPresenter
          }
        end

        def sign_bureau_operations
          {
            current_user: current_user,
            params: params,
            contract_class: Contracts::Me::SignBureauContract,
            presenter_class: Presenters::EmptyPresenter
          }
        end

        def fetch_options
          {
            params: params.merge!(page: { size: 0 }, user_id: current_user.id),
            model_class: LegalDocument,
            allowed_includes: self.class.allowed_includes,
            allowed_sorts: self.class.allowed_sorts,
            presenter_class: Presenters::Me::LegalDocumentsPresenter,
            default_scope: lambda { |query|
              Queries::Me::ObtainLoanLegalDocumentsQuery.new(query).call(current_user.id)
            }
          }
        end
      end
    end
  end
end
