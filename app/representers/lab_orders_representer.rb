# frozen_string_literal: true

class LabOrdersRepresenter
  def initialize(lab_orders)
    @lab_orders = lab_orders
  end

  def as_json
    lab_orders.map do |lab_order|
      {
        id: lab_order.id,
        qrcode: lab_order.qrcode,
        patient_name: "#{lab_order.patient.first_name} #{lab_order.patient.first_name}",
        blood_type: lab_order.blood_type,
        tissue_name: lab_order.tissue_name,
        requested_by: lab_order.requested_by,
        taken_by: lab_order.taken_by,
        created_at: lab_order.created_at
      }
    end
  end

  private

  attr_reader :lab_orders
end
