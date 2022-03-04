class Result < ApplicationRecord
  belongs_to :lab_order
  validates :patient_name, :blood_type, :temperature
end
