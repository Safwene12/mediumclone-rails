class ArticleSerializer < ActiveModel::Serializer
  attributes :title, :slug, :favorites_count, :description, :body, :favoritesCount, :tagList
  attribute :updated_at, key: "updatedAt"
  attribute :created_at, key: "createdAt"
  has_one :author, serializer: AuthorSerializer

  def favoritesCount
    # we can works with object. like self. in the model
    # To be implemented
    0
  end

  def tagList
    object.tags.map(&:name)
  end
end
