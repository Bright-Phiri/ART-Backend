class BloodGroup < ApplicationRecord
    validates :name, presence: true, uniqueness: true
end
