class MealPost < ApplicationRecord
  belongs_to :user
  has_many :votes, dependent: :destroy
  has_many :food_items, dependent: :destroy
  accepts_nested_attributes_for :food_items, reject_if: proc { |attr| attr['name'].blank? && attr['amount'].blank? && attr['calory'].blank? }

  has_many :upvotes, -> { where(is_upvote: true) }, class_name: 'Vote'
  has_many :downvotes, -> { where(is_upvote: false) }, class_name: 'Vote'
  has_many :upvoters, through: :upvotes, source: :user
  has_many :downvoters, through: :downvotes, source: :user

  default_scope { order(time: :desc) }
  scope :is_upvoted, -> { where(is_upvote: true) }
  scope :is_downvoted, -> { where(is_upvote: false) }

  before_validation :strip_whitespaces, only: %i[content]
  validates :user_id, presence: true
  validates :time, presence: true
  validates :content, presence: true, length: { maximum: 200 }
  validates :food_items, length: { minimum: 1, message: 'should have at least 1 food item.' }

  def score
    # TODO: 負荷が高いのでバッチ処理化 or SQLの集計関数を使う
    votes.all.map { |v| v.is_upvote? ? 1 : -1 }.sum
  end

  private

  def strip_whitespaces
    content&.strip!
  end

  def has_at_least_1_food_item; end
end
