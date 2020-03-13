class MealPostsController < ApplicationController
  def create
    current_user.meal_posts.build(meal_post_params).save
  end

  # TODO
  def destroy; end

  def show
    @meal_post = MealPost.find(params[:id])
  end

  private

  def meal_post_params
    params.require(:meal_post).permit(:content, 'time(1i)', 'time(2i)', 'time(3i)', 'time(4i)', 'time(5i)')
  end
end
