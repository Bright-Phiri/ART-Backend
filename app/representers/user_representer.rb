# frozen_string_literal: true

class UserRepresenter
  def initialize(user)
    @user = user
  end

  def as_json
    {
      id: user.id,
      username: user.username,
      email: user.email,
      phone: user.phone,
      role: user.role,
      avatar: user.avatar.url
    }
  end

  private

  attr_reader :user
end
