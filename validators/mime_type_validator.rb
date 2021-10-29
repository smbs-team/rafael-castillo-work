# frozen_string_literal: true

# Custom validator for signature format
class MimeTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    extensions = options.fetch(:in, %w[image/jpeg image/png])
    return if  value.is_a?(ActionDispatch::Http::UploadedFile) && extensions.include?(value.content_type)

    record.errors.add attribute, (options[:message] || "must be in formats: #{extensions.join(',')}")
  end
end
