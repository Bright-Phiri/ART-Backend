# frozen_string_literal: true

class ResultRepresenter
  def initialize(result)
    @result = result
  end

  def as_json
    {
      id: result.id,
      lab_order_id: result.lab_order_id,
      patient_name: result.patient_name,
      blood_type: result.blood_type,
      hiv_res: result.hiv_res,
      tisuue_res: result.tisuue_res,
      created_at: result.created_at
    }
  end

  private

  attr_reader :result
end
