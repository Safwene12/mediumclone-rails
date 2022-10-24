class Article < ApplicationRecord
  before_validation :set_defaults, on: :create
  belongs_to :author, class_name: "User"
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  has_many :likes, dependent: :destroy
  has_many :user_favorites, through: :likes, source: :user

  validates :slug, presence: true, uniqueness: true
  validates :title, presence: :true
  validates :body, presence: :true
  validates :description, presence: :true
  validates :favorites_count, presence: :true

  scope :recent, -> { order(created_at: :desc) }
  scope :filter_by_tag_name, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }
  scope :by_author, ->(author_username) { joins(:author).where(author: { username: author_username }) }
  scope :liked, ->(user_id) { joins(:user_favorites).where(user_favorites: { id: user_id }) }

  def set_defaults
    self.favorites_count = 0
    self.slug = self.generate_slug
  end

  def generate_slug
    loop do
      token = SecureRandom.hex(10)
      break "Title#{token}"
    end
  end

  def self.update_tags(article, new_tags = [])
    ArticleTag.where(article_id: article.id).destroy_all
    tags = article.article_tags.insert_all(new_tags)
  end
end
