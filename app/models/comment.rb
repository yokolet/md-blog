class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates_presence_of :body
  validates_length_of :body, minimum: 1, maximum: 300
end
