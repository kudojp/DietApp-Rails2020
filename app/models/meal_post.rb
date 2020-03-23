class MealPost < ApplicationRecord
  belongs_to :user
  default_scope { order(time: :desc) }

  before_validation :strip_whitespaces, only: %i[content]
  validates :user_id, presence: true
  validates :time, presence: true
  validates :content, presence: true, length: { maximum: 200 }

  private

  def strip_whitespaces
    content&.strip!
  end
end
