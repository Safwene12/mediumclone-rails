class ArticleSerializer < ActiveModel::Serializer
  attributes :title, :slug, :description, :body, :favorited, :tagList, :favoritesCount
  attribute :updated_at, key: "updatedAt"
  attribute :created_at, key: "createdAt"
  has_one :author, serializer: AuthorSerializer

  def favorited
    if !current_user
      return false
    end
    isLiked = Like.where(user_id: current_user.id, article_id: object.id).first
    if isLiked
      return true
    else
      return false
    end
  end

  def favoritesCount
    return Like.where(article_id: object.id).count
  end

  def current_user
    scope
  end

  def tagList
    object.tags.map(&:name)
  end
end
