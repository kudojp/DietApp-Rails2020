class AddColumnsToMealPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :meal_posts, :total_calories, :integer, default: nil
    add_column :meal_posts, :food_items_count, :integer, default: 0, null: false
    add_column :meal_posts, :food_items_with_calories_count, :integer, default: 0, null: false

    # counter_cache for existing records
    FoodItem.counter_culture_fix_counts
  end
end
