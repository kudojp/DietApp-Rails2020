class MealPostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @new_meal_post = current_user.meal_posts.build(meal_post_params)

    if @new_meal_post.save
      return respond_to do |format|
        # TODO: friendly forwardingを実装
        format.html { redirect_to root, notice: 'You successfully made a meal post.' }
        format.js
      end
    end

    respond_to do |format|
      # TODO: friendly forwardingを実装
      # TODO: errorを伝搬するなりして、alertをもう少しdescriptiveにする
      format.html { redirect_to root, alert: 'You could not make a meal post.' }
      format.js do
        render partial: 'meal_posts/create_failure', status: :bad_request
      end
    end
  end

  def destroy
    @meal_post = MealPost.find(params[:id])
    return redirect_to root_path, alert: 'You are not authorized to delete the post' if @meal_post.user_id == current_user

    @meal_post.destroy
    respond_to do |format|
      # TODO: friendly forwardingを実装
      format.html { redirect_to root }
      format.js
    end
  end

  def show
    @meal_post = MealPost.find(params[:id])
  end

  def upvoted_index
    # TODO
  end

  def downvoted_index
    # TODO
  end

  private

  def meal_post_params
    params.require(:meal_post).permit(:content, :time)
  end
end
