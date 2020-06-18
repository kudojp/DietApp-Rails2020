class HomeController < ApplicationController
  def index
    @user = current_user
    @meal_posts = @user&.meal_posts_feed&.includes(:user)
    @new_meal_post = @user&.meal_posts&.new
    3.times { @new_meal_post&.food_items&.build }
  end
end
