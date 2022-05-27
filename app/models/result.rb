class Result < ApplicationRecord
  belongs_to :lab_order
  validates :patient_name, :blood_type, :hiv_res, :tisuue_res, :conducted_by, presence: true
end
