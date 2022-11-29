class Patient < ApplicationRecord
    has_many :lab_orders, inverse_of: :patient, dependent: :destroy
    validates :first_name, :last_name, :gender, :dob, :district, :village, :phone, :location, presence: true
    validate :date_of_birth_cannot_be_in_the_future
    VALID_GENDERS = ['Male','Female'].freeze
    validates :gender, inclusion: { in: VALID_GENDERS }
    validates :phone, phone: true, uniqueness: true ,numericality: { only_integer: true }
    after_commit :publish_to_dashboard, on: [:create, :destroy] 
    scope :male_patients, ->{ where(gender: VALID_GENDERS.first) }
    scope :female_patients, ->{ male_patients.invert_where }
    include Filterable

    def full_name
        "#{first_name} #{last_name}"
    end

    private
    def date_of_birth_cannot_be_in_the_future
        if dob.present? && dob > Date.today
            errors.add :dob, message: " cannot be in the future"
        end
    end

    def publish_to_dashboard
        DashboardSocketDataJob.perform_later({res: 'patients', patients: Patient.count}.as_json)
    end
end
