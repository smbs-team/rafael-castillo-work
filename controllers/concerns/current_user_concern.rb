# frozen_string_literal: true

# assigns current_user id to user_id on contracts
module CurrentUserConcern
  extend ActiveSupport::Concern
  included do
    self.operation_class = {
      index: Paw::Operations::Api::Finder,
      show: Paw::Operations::Api::Finder,
      create: Operations::CurrentUserOperation,
      update: Operations::Me::UpdateOwnedResourceOperation
    }.with_indifferent_access
  end
end
