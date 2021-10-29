# frozen_string_literal: true

# Custom Validator for Gender
class GenderValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || 'is not a valid gender') unless
      %w[Male Female].include?(value)
  end
end
