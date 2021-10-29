# frozen_string_literal: true

# Custom Validator for Mutuo Types
class MutuoTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || 'is not a valid mutuo type') unless
      %w[Cooperative Natural Juridical].include?(value)
  end
end
