# frozen_string_literal: true

# assigns current_user id to user_id on contracts
module MtsConcern
  extend ActiveSupport::Concern
  included do
    self.operation_class = {
      index: Paw::Operations::Api::Finder,
      show: Paw::Operations::Api::Finder,
      create: Paw::Operations::Api::Form,
      update: Paw::Operations::Api::Form
    }.with_indifferent_access
  end
end
