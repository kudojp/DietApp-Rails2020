class FoodItem < ApplicationRecord
  belongs_to :meal_post

  before_validation :strip_whitespaces
  validates :name, presence: true, length: { maximum: 50 }
  validates :amount, length: { maximum: 30 }, allow_blank: true
  validates :calory, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

  private

  def strip_whitespaces
    name&.strip!
    amount&.strip!
  end
end
