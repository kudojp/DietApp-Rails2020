class VotesController < ApplicationController
  def upvote
    meal_post = MealPost.find(params[:meal_post_id])
    current_user.change_vote_state(true, meal_post)
    respond_to do |format|
      format.html { redirect_to meal_post, status: :see_other, notice: 'Your voting completed successfully' }
      format.js do
        render template: 'votes/update_vote_icon', locals: { meal_post: meal_post }, status: :ok
      end
    end
  end

  def downvote
    meal_post = MealPost.find(params[:meal_post_id])
    current_user.change_vote_state(false, meal_post)
    respond_to do |format|
      format.html { redirect_to meal_post, status: :see_other, notice: 'Your voting completed successfully' }
      format.js do
        render template: 'votes/update_vote_icon', locals: { meal_post: meal_post }, status: :ok
      end
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:meal_post, :is_upvote)
  end
end
