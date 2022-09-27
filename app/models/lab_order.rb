class LabOrder < ApplicationRecord
  belongs_to :patient
  has_one :result, dependent: :destroy
  validates :qrcode, :blood_type, :tissue_name, :requested_by, :taken_by, presence: true
  validates :qrcode, uniqueness: true
  validates :blood_type, inclusion: {in: Proc.new {BloodGroup.pluck(:name)}}
  default_scope {order(:created_at).reverse_order}
  include Filterable
  scope :statistics,->{created_in(Date.current.year).select(:id, :created_at,'COUNT(id)').group(:id)}
  scope :unverified_lab_orders,-> {where(verified: false)}
  scope :verified_lab_orders,-> {unverified_lab_orders.invert_where}
  enum :status, [:active, :archived], suffix: true, default: :active

  after_commit :broadcast_data, on: [:create, :update, :destroy]

  def created_at
    attributes['created_at'].strftime("%Y-%m-%d")
  end

  private

  def broadcast_data
     DashboardSocketDataJob.perform_later({res: 'lab_orders_count',lab_orders: LabOrder.unscoped.statistics, lab_orders_count: LabOrder.active_status.count}.as_json)
     NotificationRelayJob.perform_later({unverified_lab_orders_count: LabOrder.unverified_lab_orders.count}.as_json)
  end
end
