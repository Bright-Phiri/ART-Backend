# frozen_string_literal: true

class Result < ApplicationRecord
  belongs_to :lab_order
  validates :patient_name, :blood_type, :hiv_res, :conducted_by, presence: true
  validates :tisuue_res, presence: true, allow_blank: true
  include Filterable
  after_commit :publish_to_dashboard, on: [:create, :destroy]

  private

  def publish_to_dashboard
    DashboardSocketDataJob.perform_later({ res: 'results', results: Result.count })
  end
end
