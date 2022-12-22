# frozen_string_literal: true

class PatientsRepresenter
  def initialize(patients)
    @patients = patients
  end

  def as_json
    patients.map do |patient|
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
  end

  private

  attr_reader :patients
end
