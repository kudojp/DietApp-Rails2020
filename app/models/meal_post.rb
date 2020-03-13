class MealPost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(time: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 200 }
end
