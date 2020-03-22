class VotesController < ApplicationController
  def create
    @new_vote = current_user.votes.build(vote_params)
  end

  def destroy; end

  private

  def vote_params
    params.require(:vote).permit(:meal_post, :is_upvote)
  end
end
