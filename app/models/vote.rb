class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :meal_post
  validates :user, :meal_post, :is_upvote, presence: true
  validates :user, uniqueness: { scope: %i[meal_post is_upvote] }
end
