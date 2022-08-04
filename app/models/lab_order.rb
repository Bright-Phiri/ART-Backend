class LabOrder < ApplicationRecord
  belongs_to :patient
  has_one :result, dependent: :destroy
  validates :qrcode, :blood_type, :tissue_name, :requested_by, :taken_by, presence: true
  VALID_BLOOD_TYPES = ['Group A', 'Group B', 'Group AB', 'Group O']
  validates :qrcode, uniqueness: true
  validates :blood_type, inclusion: {in: VALID_BLOOD_TYPES}
  default_scope {order(:created_at).reverse_order}
  scope :statistics,->{select(:id, :created_at, 'COUNT(id)').group(:id)}
  enum :status, [:active, :archived], suffix: true, default: :active

  after_commit :broadcast_data, on: [:create, :update, :destroy]

  def created_at
    attributes['created_at'].strftime("%Y-%m-%d")
  end

  private

  def broadcast_data
     DashboardSocketDataJob.perform_later({res: 'lab_orders_count',lab_orders: LabOrder.unscoped.statistics, lab_orders_count: LabOrder.active_status.count}.as_json)
  end
end
