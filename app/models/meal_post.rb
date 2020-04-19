class MealPost < ApplicationRecord
  belongs_to :user
  has_many :votes, dependent: :destroy
  default_scope { order(time: :desc) }
  scope :is_upvoted, -> { where(is_upvote: true) }
  scope :is_downvoted, -> { where(is_upvote: false) }

  before_validation :strip_whitespaces, only: %i[content]
  validates :user_id, presence: true
  validates :time, presence: true
  validates :content, presence: true, length: { maximum: 200 }

  def score
    votes.all.map { |v| v.is_upvote? ? 1 : -1 }.sum
  end

  private

  def strip_whitespaces
    content&.strip!
  end
end
