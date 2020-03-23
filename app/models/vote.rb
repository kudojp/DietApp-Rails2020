class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :meal_post
  validates :user, :meal_post, presence: true
  validates_inclusion_of :is_upvote, in: [true, false]
  validates :user, uniqueness: { scope: %i[meal_post] }
end
