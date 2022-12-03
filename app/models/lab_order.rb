# frozen_string_literal: true

class LabOrder < ApplicationRecord
  default_scope { order(:created_at).reverse_order }
  scope :statistics, -> { created_in(Date.current.year).select(:id, :created_at, 'COUNT(id)').group(:id) }
  scope :unverified_lab_orders, -> { where(verified: false) }
  scope :verified_lab_orders, -> { unverified_lab_orders.invert_where }
  include Filterable
  enum :status, [:active, :archived], suffix: true, default: :active
  belongs_to :patient
  has_one :result, dependent: :destroy
  validates :qrcode, :blood_type, :requested_by, :taken_by, presence: true
  validates :tissue_name, presence: true, allow_blank: true
  validates :qrcode, uniqueness: true
  validates :blood_type, inclusion: { in: Proc.new { BloodGroup.pluck(:name).freeze } }
  include ActiveModel::Validations
  validates_with LabOrderValidator
  after_commit :publish_to_dashboard, on: [:create, :update, :destroy]

  def created_at
    attributes['created_at'].strftime('%Y-%m-%d')
  end

  private

  def publish_to_dashboard
    DashboardSocketDataJob.perform_later({ res: 'lab_orders_count', lab_orders: LabOrder.unscoped.statistics, lab_orders_count: LabOrder.active_status.count }.as_json)
    NotificationRelayJob.perform_later({ unverified_lab_orders_count: LabOrder.unverified_lab_orders.count }.as_json)
  end
end
