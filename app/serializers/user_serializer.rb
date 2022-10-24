class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :bio, :image, :token
  attribute :updated_at, key: "updatedAt"
  attribute :created_at, key: "createdAt"

  def token
    User.encode_token({ user_id: object.id })
  end
end
