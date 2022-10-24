class ProfileSerializer < ActiveModel::Serializer
  attributes :username, :bio, :image, :following

  def following
    false
  end
end
