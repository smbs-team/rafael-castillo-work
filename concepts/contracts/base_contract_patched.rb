# frozen_string_literal: true

module Contracts
  # Contract Object to patch many_populator
  class BaseContractPatched < Paw::Contracts::Api::BaseContract
    def many_populator!(collection:, index:, fragment:, as:, **_options)
      item = self.class.definitions[as][:nested].new(OpenStruct.new(fragment))
      collection.insert(index, item)
    end
  end
end
