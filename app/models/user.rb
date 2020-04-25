class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :meal_posts, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_many :upvotes, -> { where(is_upvote: true) }, class_name: 'Vote'
  has_many :downvotes, -> { where(is_upvote: false) }, class_name: 'Vote'
  has_many :favorite_meal_posts, through: :upvotes, source: :meal_post
  has_many :unfavorite_meal_posts, through: :downvotes, source: :meal_post

  before_validation :strip_whitespaces, only: %i[name account_id]
  validates :name, presence: true, length: { in: 1..20 }
  validates :account_id, presence: true, length: { in: 5..15 }, uniqueness: true,
                         format: { with: /\A[A-Za-z0-9]+\z/, message: 'should be alphanumeric' }

  def follow(other_user)
    followings << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by!(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def meal_posts_feed
    following_users_and_self = followings + [self]
    MealPost.where(user: following_users_and_self)
  end

  # returns
  #     true (when given meal_post is already up(down)voted by current user)
  #     false (when given meal_post is not up(down)voted by current user yet)
  def voted?(is_upvote, meal_post)
    votes.where(meal_post: meal_post, is_upvote: is_upvote).exists?
  end

  # returns
  #     Vote object (when vote is successfully updated)
  #     nil (when vote from curent user to given vote in the same direction already exists)
  def change_vote_state(pushed_upvote, meal_post)
    # If already voted in the same direction...
    if voted?(pushed_upvote, meal_post)
      votes.where(meal_post: meal_post, is_upvote: pushed_upvote).destroy_all
      return
    end
    votes.where(meal_post: meal_post).destroy_all
    votes.create!(meal_post: meal_post, is_upvote: pushed_upvote)
  end

  private

  def strip_whitespaces
    name&.strip!
    account_id&.strip!
  end
end
