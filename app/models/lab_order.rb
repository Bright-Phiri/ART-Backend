class LabOrder < ApplicationRecord
  belongs_to :patient
  has_one :result, dependent: :destroy
  has_one :result_archieve, dependent: :destroy
  validates :qrcode, :blood_type, :tissue_name, :requested_by, :taken_by, presence: true
  VALID_BLOOD_TYPES = ['Group A', 'Group B', 'Group AB', 'Group O']
  validates :qrcode, uniqueness: true
  validates :blood_type, inclusion: {in: VALID_BLOOD_TYPES}
  default_scope {order(:created_at).reverse_order}
end
