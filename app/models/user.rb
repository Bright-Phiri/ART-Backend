class User < ApplicationRecord
    has_secure_password
    has_one_attached :avatar
    validates :avatar, attached: true, size: { less_than: 4.megabytes , message: ' is too large' }
    validates :username, presence: true, uniqueness: true, format: { without: /\s/, message: ' must contain no spaces' }
    validates :phone, phone: true, uniqueness: true, numericality: {only_integer: true}
    VALID_ROLES = ['Admin', 'Lab Assistant', 'HDA Personnel'].freeze
    validates :role, presence: true, inclusion: {in: VALID_ROLES}
    validates :email, presence: true, uniqueness: true, email: true
    validates :password, length: {in: 6..8}
    scope :lab_assistants,->{where(role: 'Lab Assistant')}
    scope :hda_personnels,->{where(role: 'HDA Personnel')}

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
