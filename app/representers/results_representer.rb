# frozen_string_literal: true

class ResultsRepresenter
  def initialize(results)
    @results = results
  end

  def as_json
    results.map do |result|
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
  end

  private

  attr_reader :results
end
