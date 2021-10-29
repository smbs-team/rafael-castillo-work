# frozen_string_literal: true

module Operations
  module Me
    class LoanLegalDocumentsList < Trailblazer::Operation
      delegate :error!, to: Paw::Utils
      pass :setup_user!
      pass :get_loan_legal_documents!
      pass :append_access_contract!
      pass :present!

      private

      def setup_user!(options, **)
        options[:user] = User.find(options[:params][:user_id])
      end

      def get_loan_legal_documents!(options, user:, **)
        loan_docs = Queries::Me::ObtainLoanLegalDocumentsQuery
                    .new(LegalDocument)
                    .call(user.id)
                    .to_a

        options[:legal_docs] = loan_docs
      end

      def append_access_contract!(_options, legal_docs:, user:, **)
        access_contract = user.legal_documents.access_contract.last
        return if access_contract.nil? || access_contract.signed

        legal_docs << access_contract
      end

      def present!(options, legal_docs:, **)
        data = legal_docs.map { |doc| options[:presenter_class].new(doc).to_hash }
        options[:response] = { data: data }
      end
    end
  end
end
