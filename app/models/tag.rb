class Tag < ApplicationRecord
  has_many :article_tags, dependent: :destroy
  has_many :articles, through: :article_tags
  validates :name, presence: true, uniqueness: true

  # we will give an array of tags name as input
  # it wil iterate the array and check each tag if exist it returns the id else it adds the tag and return the if
  # And return an array of ids as output
  def self.ids_from_names(tags_name = [])
    tags_id = []
    tags_name.each { |tag|
      tag = self.find_or_create_by(name: tag)
      if !tag.save
        return tag.errors
      end
      tags_id.append({ tag_id: tag.id })
    }
    # uniq to remove duplcated values
    return tags_id.uniq
  end
end
