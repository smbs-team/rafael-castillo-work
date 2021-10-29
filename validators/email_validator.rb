# frozen_string_literal: true

# Custom Validator for Email
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, message unless
      value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end

  private

  def message
    options[:message] || I18n.t('activerecord.errors.models.user.attributes.email.taken')
  end
end
