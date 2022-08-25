class User < ApplicationRecord
    has_secure_password
    has_one_attached :avatar
    include ActiveModel::Validations
    validates_with PhoneValidator
    validates :avatar, attached: true, size: { less_than: 4.megabytes , message: ' is too large' }
    validates :username, presence: true, uniqueness: true, format: { without: /\s/, message: ' must contain no spaces' }
    validates :phone, presence: true, uniqueness: true, numericality: {only_integer: true}
    VALID_ROLES = ['Admin', 'Lab Assistant', 'HDA Personnel']
    validates :role, presence: true, inclusion: {in: VALID_ROLES}
    validates :email, presence: true, uniqueness: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i ,message: ' Entered is invalid'}
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
       
    def reset_password!(password)
        self.reset_password_token = nil
        self.password = password
        self.password_confirmation = password
        save!(validate: false)
    end
       
    private
       
    def generate_token
        SecureRandom.hex(10)
    end
end
