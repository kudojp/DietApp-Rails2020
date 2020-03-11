class RelationshipsController < ApplicationController
  before_action :user_signed_in?
  def create
    @followed_user = User.find(params[:followed_id])
    current_user.follow(@followed_user)

    respond_to do |format|
      format.html { redirect_to @followed_user }
      format.js
    end
  end

  def destroy
    @followed_user = Relationship.find(params[:id]).followed
    current_user.unfollow(@followed_user)

    respond_to do |format|
      format.html { redirect_to @followed_user }
      format.js
    end
  end
end
