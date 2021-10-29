# frozen_string_literal: true

# Custom Validator for Array of numbers
class ArrayOfNumbersValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || 'field must be an array of numbers') unless
      check_array(value)
  end

  private

  def check_array(value)
    value.is_a?(Array) && value.all? { |number| number.to_i != 0 }
  end
end
