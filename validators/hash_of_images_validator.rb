# frozen_string_literal: true

# Custom Validator for Array of numbers
class HashOfImagesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || 'field must be an array of images') unless
    check_array(value)
  end

  private

  def check_array(value)
    extensions = options.fetch(:in, %w[image/jpeg image/png])
    value.is_a?(Hash) && value.values.all? do |image|
      image.is_a?(ActionDispatch::Http::UploadedFile) &&
        extensions.include?(image.content_type)
    end
  end
end
