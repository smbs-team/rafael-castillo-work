# frozen_string_literal: true

module Presenters
  module Me
    # Serializer/presenter for Update Device contacts Sync Date request
    class UpdateDeviceContactsSyncPresenter < Paw::Presenters::Api::BasePresenter
      property :contacts_last_sync_at
    end
  end
end
