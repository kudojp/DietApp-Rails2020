class VotesController < ApplicationController
  def upvote
    vote(true)
  end

  def downvote
    vote(false)
  end

  private

  def vote_params
    params.require(:vote).permit(:meal_post, :is_upvote)
  end

  def vote(is_up)
    meal_post = MealPost.find(params[:meal_post_id])

    begin
      current_user.change_vote_state(is_up, meal_post)
    rescue ActiveRecord::RecordInvalid => e
      return respond_to do |format|
        format.html { redirect_to meal_post, status: :see_other, notice: e }
        format.js do
          render template: 'votes/vote_failure', locals: { message: e }, status: :bad_request
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to meal_post, status: :see_other, notice: 'Your voting completed successfully' }
      format.js do
        render template: 'votes/update_vote_icon', locals: { meal_post: meal_post }, status: :ok
      end
    end
  end
end
