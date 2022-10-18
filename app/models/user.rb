class User < ApplicationRecord
  after_initialize :set_defaults

  has_secure_password
  attr_accessor :token

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: :true, uniqueness: :true
  validates :password, presence: true, length: { minimum: 8, maximum: 254 }

  def set_defaults
    self.image = "https://www.nicepng.com/png/detail/933-9332131_profile-picture-default-png.png"
  end
end