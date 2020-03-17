class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    # TODO: what if not-existing/already-following user_id is specitied?
    @followed_user = User.find(params[:followed_id])
    current_user.follow(@followed_user)

    respond_to do |format|
      format.html { redirect_to @followed_user }
      format.js
    end
  end

  def destroy
    # TODO: what if not-existing/not-followign user_id is specitied?
    @followed_user = Relationship.find(params[:id]).followed
    current_user.unfollow(@followed_user)

    respond_to do |format|
      format.html { redirect_to @followed_user }
      format.js
    end
  end
end
