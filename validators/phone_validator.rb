# frozen_string_literal: true

# Custom Validator for Phone number
class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # Only checks for 8-digit numbers ()
    record.errors.add attribute, (options[:message] || 'is not a valid phone number') unless
      value =~ /\b[6-7]{1}[0-9]{7}\b/
  end
end
