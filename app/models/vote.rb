class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :meal_post

  validates :user, :meal_post, presence: true
  validates_inclusion_of :is_upvote, in: [true, false]
  validates :user, uniqueness: { scope: %i[meal_post] }

  validate :cannot_vote_own_meal_post

  def cannot_vote_own_meal_post
    errors.add(:meal_post, 'cannot vote own meal post') if user == meal_post&.user
  end
end
