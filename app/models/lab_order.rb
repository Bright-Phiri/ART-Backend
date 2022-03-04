class LabOrder < ApplicationRecord
  belongs_to :patient
  has_one :result
  validates :qrcode, :blood_type, :temperature, presence: true
  VALID_BLOOD_TYPES = ['Group A', 'Group B', 'Group AB', 'Group O']
  validates :qrcode, uniqueness: true
  validates :blood_type, inclusion: {in: VALID_BLOOD_TYPES}
  validates :temperature, numericality: true
end
