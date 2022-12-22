# frozen_string_literal: true

class UsersRepresenter
  def initialize(users)
    @users = users
  end

  def as_json
    users.map do |user|
      {
        id: user.id,
        username: user.username,
        email: user.email,
        phone: user.phone,
        role: user.role,
        avatar: user.avatar.url
      }
    end
  end

  private

  attr_reader :users
end
