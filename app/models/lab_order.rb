class LabOrder < ApplicationRecord
  belongs_to :patient
  has_one :result, dependent: :destroy
  has_one :result_archieve, dependent: :destroy
  validates :qrcode, :blood_type, :temperature, presence: true
  VALID_BLOOD_TYPES = ['Group A', 'Group B', 'Group AB', 'Group O']
  validates :qrcode, uniqueness: true
  validates :blood_type, inclusion: {in: VALID_BLOOD_TYPES}
  validates :temperature, numericality: true
  default_scope {order(:created_at).reverse_order}
end
