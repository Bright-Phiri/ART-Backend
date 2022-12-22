# frozen_string_literal: true

class LabOrderRepresenter
  def initialize(lab_order)
    @lab_order = lab_order
  end

  def as_json
    {
      id: lab_order.id,
      qrcode: lab_order.qrcode,
      blood_type: lab_order.blood_type,
      tissue_name: lab_order.tissue_name,
      requested_by: lab_order.requested_by,
      taken_by: lab_order.taken_by,
      created_at: lab_order.created_at
    }
  end

  private

  attr_reader :lab_order
end
