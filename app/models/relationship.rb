class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :follower_id, presence: true, uniqueness: { scope: [:followed_id] }
  validates :followed_id, presence: true
  validate :cannot_follow_self_account

  def cannot_follow_self_account
    errors.add(:relationship, 'cannot follow self account') if follower == followed
  end
end
