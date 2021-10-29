# frozen_string_literal: true

module Presenters::Me
  class ReferredCodeCheckingPresenter < Paw::Presenters::Api::BasePresenter
    property :result, documentation: { type: :boolean }
  end
end
