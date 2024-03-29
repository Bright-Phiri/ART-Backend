# frozen_string_literal: true

class Result < ApplicationRecord
  include Filterable
  belongs_to :lab_order
  validates :patient_name, :blood_type, :hiv_res, :conducted_by, presence: true
  validates :tisuue_res, presence: true, allow_blank: true
  after_commit :publish_to_dashboard, on: [:create, :destroy]

  private

  def publish_to_dashboard
    DashboardSocketDataJob.perform_later('results')
  end
end
