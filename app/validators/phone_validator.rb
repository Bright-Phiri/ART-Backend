# frozen_string_literal: true

class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || 'number is invalid') unless value =~ /\A(\+?(265|0){1}(1|88[0-9]|99[0-9]|98[0-9]|90[0-9]){1}[0-9]{6})\z/
  end
end
