# frozen_string_literal:true

module Api
  module V1
    # Docs controller
    class DocsController < ActionController::Base
      include Paw::Concerns::SwaggerConcern
      include ApiDocsConcern # includes custom Authentication Documentation

      def index; end

      def swagger
        I18n.with_locale(:en) do
          render json: Swagger::Blocks.build_root_json(
            Paw::SwaggerDoc.swagger_classes
          )
        end
      end
    end
  end
end
