class UserSerializer
  include FastJsonapi::ObjectSerializer
  attribute :id do |user|
    user.id
  end
  attribute :email do |user|
    user.email
  end
end
