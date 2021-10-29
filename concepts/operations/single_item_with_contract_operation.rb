# frozen_string_literal: true

module Operations
  # Operation to return a single object without identifier
  class SingleItemWithContractOperation < Operations::FinderWithContractOperation
    private

    def model!(options, models:, collection:, **)
      options[:model] = models.first if options[:model].nil? && !collection
      options
    end
  end
end
