class FoodItem < ApplicationRecord
  belongs_to :meal_post
  counter_culture :meal_post
  counter_culture :meal_post, column_name: proc { |model| model.calory.nil? ? nil : 'food_items_with_calories_count' },
                              column_names: { ['food_items.calory IS NOT NULL'] => 'food_items_with_calories_count' }
  counter_culture :meal_post, column_name: 'total_calories', delta_column: 'calory'

  before_validation :strip_whitespaces
  validates :name, presence: true, length: { maximum: 30 }
  validates :amount, length: { maximum: 30 }, allow_blank: true
  validates :calory, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

  private

  def strip_whitespaces
    name&.strip!
    amount&.strip!
  end
end
