class Result < ApplicationRecord
  belongs_to :lab_order
  validates :patient_name, :blood_type, :hiv_res, :conducted_by, presence: true
  validates :tisuue_res, presence: true, allow_blank: true
  include Filterable
  after_commit :broadcast_data, on: [:create, :destroy]

  private 
  def broadcast_data
      DashboardSocketDataJob.perform_later({res: 'results', results: Result.count}.as_json)
  end
end
