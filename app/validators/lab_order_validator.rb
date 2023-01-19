# frozen_string_literal: true

class LabOrderValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :base, :invalid, message: 'Lab order already verified' if record.verified == true
  end
end
