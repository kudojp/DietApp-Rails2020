module MealPostsHelper
  def total_calories_of(meal_post)
    return '- kcal' if meal_post.food_items_with_calories_count.zero?
    return "#{meal_post.total_calories}kcal+" if meal_post.food_items_count != meal_post.food_items_with_calories_count

    "#{meal_post.total_calories}kcal"
  end

  def total_count_and_calories_of(meal_post)
    "#{meal_post.food_items_count}品 合計#{total_calories_of(meal_post)}"
  end
end
