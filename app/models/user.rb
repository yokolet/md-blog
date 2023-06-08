class User < ApplicationRecord
  enum provider: [:local, :twitter]
  # validation
  validates_presence_of :provider, :uid, :username, :access_token, :expiry
  # Association
  has_many :posts, dependent: :destroy
  has_many :comments, through: :posts

  def self.from_auth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.username = auth.info.username
    end
  end
end
