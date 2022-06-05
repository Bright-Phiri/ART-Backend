class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :username, :email, :phone, :role
end
