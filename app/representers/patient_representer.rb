# frozen_string_literal: true

class PatientRepresenter
  def initialize(patient)
    @patient = patient
  end

  def as_json
    {
      id: patient.id,
      first_name: patient.first_name,
      last_name: patient.last_name,
      gender: patient.gender,
      dob: patient.dob,
      village: patient.village,
      district: patient.district,
      phone: patient.phone,
      location: patient.location
    }
  end

  private

  attr_reader :patient
end
