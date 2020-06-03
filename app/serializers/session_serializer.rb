class SessionSerializer
  include FastJsonapi::ObjectSerializer
  attribute :id do |token|
    token.user.id
  end
  attribute :email do |token|
    token.user.email
  end

  attribute :token do |token|
    token.token
  end
end
