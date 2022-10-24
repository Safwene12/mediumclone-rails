class AuthorSerializer < ActiveModel::Serializer
  attributes :username, :image, :bio
end
