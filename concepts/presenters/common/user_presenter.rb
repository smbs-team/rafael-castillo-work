# frozen_string_literal: true

module Presenters
  module Common
    # Serializer/presenter for User model
    class UserPresenter < Paw::Presenters::Api::BasePresenter
      property :id
      property :first_name, render_nil: false
      property :last_name, render_nil: false
      property :phone_number
      property :email, render_nil: false
      property :monthly_income
      property :user_type, exec_context: :decorator
      property :created_at
      property :truthful_information, render_nil: false
      property :birth_date, render_nil: false
      property :marital_status, render_nil: false
      property :trade, render_nil: false
      property :gender, render_nil: false
      property :segment, exec_context: :decorator, render_nil: false
      property :dui, exec_context: :decorator, render_nil: false
      property :nit, exec_context: :decorator, render_nil: false
      property :loan_status, exec_context: :decorator, render_nil: false
      collection :addresses, decorator: Presenters::Me::AddressPresenter, class: Address
      property :bureau_signed?

      def user_type
        represented.user_type_before_type_cast
      end

      def segment
        represented.segment_label
      end

      def dui
        represented.dui_number
      end

      def nit
        represented.nit_number
      end

      def loan_status
        represented.last_loan
      end
    end
  end
end
