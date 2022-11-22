class User < ApplicationRecord
    has_secure_password
    has_one_attached :avatar
    VALID_ROLES = ['Admin', 'Lab Assistant', 'HDA Personnel'].freeze
    validates :avatar, attached: true, size: { less_than: 4.megabytes , message: ' is too large' }
    validates :phone, phone: true, uniqueness: true, numericality: {only_integer: true}
    with_options presence: true do
       validates :username, uniqueness: true, format: { without: /\s/, message: ' must contain no spaces' }
       validates :role, inclusion: {in: VALID_ROLES}
       validates :email, uniqueness: true, email: true
    end
    validates :password, length: {in: 6..8}
    scope :lab_assistants,->{where(role: VALID_ROLES.fetch(1))}
    scope :hda_personnels,->{where(role: VALID_ROLES.last)}

    def generate_password_token!
        self.reset_password_token = generate_token
        self.reset_password_sent_at = Time.now.utc
        save!(validate: false)
    end
       
    def password_token_valid?
        (self.reset_password_sent_at + 2.hours) > Time.now.utc
    end
       
    def reset_password!(password, password_confirmation)
        self.reset_password_token = nil
        self.password = password
        self.password_confirmation = password_confirmation
        save!
    end
       
    private 
    def generate_token
        SecureRandom.hex(10)
    end
end
