# frozen_string_literal: true

class BloodGroup < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
