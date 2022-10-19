class Article < ApplicationRecord
  after_initialize :set_defaults
  belongs_to :author, class_name: "User"
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  validates :slug, presence: true, uniqueness: true
  validates :title, presence: :true
  validates :body, presence: :true
  validates :description, presence: :true
  validates :favorites_count, presence: :true

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
end
