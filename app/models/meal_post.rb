class MealPost < ApplicationRecord
  belongs_to :user
  has_many :votes
  default_scope { order(time: :desc) }

  before_validation :strip_whitespaces, only: %i[content]
  validates :user_id, presence: true
  validates :time, presence: true
  validates :content, presence: true, length: { maximum: 200 }

  def score
    votes.all.count(&:is_upvote) - votes.all.count { |v| v.is_upvote == false }
  end

  private

  def strip_whitespaces
    content&.strip!
  end
end
