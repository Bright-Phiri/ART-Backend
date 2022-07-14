class User < ApplicationRecord
    has_secure_password
    validates :username, presence: true, uniqueness: true, format: { without: /\s/, message: ' must contain no spaces' }
    validates :phone, presence: true, uniqueness: true,numericality: {only_integer: true}, format: {with: /\A(\+?(265|0){1}(1|88[0-9]|99[0-9]|98[0-9]|90[0-9]){1}[0-9]{6})\z/, message: ' number is invalid'}
    VALID_ROLES = ['Admin', 'Lab Assistant', 'HDA Personnel']
    validates :role, presence: true, inclusion: {in: VALID_ROLES}
    validates :email, presence: true, uniqueness: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i ,message: ' Entered is invalid'}
    validates :password, length: {in: 6..8}
    scope :lab_assistants,->{where(role: 'Lab Assistant')}
    scope :hda_personnels,->{where(role: 'HDA Personnel')}

    def generate_password_token
        self.reset_password_token = generate_token
        self.reset_password_sent_at = Time.now.utc
    end
       
    def password_token_valid?
        (self.reset_password_sent_at + 2.hours) > Time.now.utc
    end
       
    def reset_password(password)
        self.reset_password_token = nil
        self.password = password
    end
       
    private
       
    def generate_token
        SecureRandom.hex(10)
    end
end
