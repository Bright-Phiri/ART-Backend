class Patient < ApplicationRecord
    has_many :lab_orders, dependent: :destroy
    validates_associated :lab_orders
    validates :first_name, :last_name, :gender, :dob, :district, :village, :phone, :location, presence: true
    validate :date_of_birth_cannot_be_in_the_future
    VALID_GENDERS = ['Male','Female']
    validates :gender, inclusion: { in: VALID_GENDERS}
    validates :phone, uniqueness: true ,numericality: { only_integer: true}

    scope :male_patients,->{where(gender: 'Male')}
    scope :female_patients,->{where(gender: 'Female')}

    private

    def date_of_birth_cannot_be_in_the_future
        if dob.present? && dob > Date.today
            errors.add :dob, message: " is Invalid"
        end
    end
end
