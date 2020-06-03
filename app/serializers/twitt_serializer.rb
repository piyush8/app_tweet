class TwittSerializer
  include FastJsonapi::ObjectSerializer
  attribute :id do |twitt|
    twitt.id
  end
  attribute :message do |twitt|
    twitt.message
  end
  attribute :twitt_user_details do |twitt|
    UserSerializer.new(twitt.user).serializable_hash[:data][:attributes]
  end
end
