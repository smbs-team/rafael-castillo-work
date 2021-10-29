# frozen_string_literal: true

module Operations
  module Me
    # Update resource owned by user
    class UpdateOwnedResourceOperation < Paw::Operations::Api::Form
      pass :find_model!, override: true

      def find_model!(options, params:, **)
        options[:model] = options[:model].call(options) if options[:model].respond_to?(:call)
        unless options[:model]
          options[:model_identifier] ||= :id
          options[:model] = options[:model_class].find_by(
            options[:model_identifier] => params[:id], user_id: options[:current_user].id
          )
        end
        error!(status: 404, message: I18n.t('paw.api.messages.not_found')) if options[:model].nil?
      end
    end
  end
end
