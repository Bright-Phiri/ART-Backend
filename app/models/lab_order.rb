class LabOrder < ApplicationRecord
  belongs_to :patient
  has_one :result, dependent: :destroy
  validates :qrcode, :blood_type, :tissue_name, :requested_by, :taken_by, presence: true
  VALID_BLOOD_TYPES = ['Group A', 'Group B', 'Group AB', 'Group O']
  validates :qrcode, uniqueness: true
  validates :blood_type, inclusion: {in: VALID_BLOOD_TYPES}
  default_scope {order(:created_at).reverse_order}
  enum status: [:active, :archived]

  def created_at
    attributes['created_at'].strftime("%Y-%m-%d")
  end
end
