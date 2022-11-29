class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :username, :email, :phone, :role

  attribute :avatar do |user|
    user.avatar
  end
end
