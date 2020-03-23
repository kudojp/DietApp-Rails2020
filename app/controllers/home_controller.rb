class HomeController < ApplicationController
  def index
    @user = current_user
    @meal_posts = @user&.meal_posts_feed&.includes(:user)
    @new_meal_post = @user&.meal_posts&.new
  end
end
