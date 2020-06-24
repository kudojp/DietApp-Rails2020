class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @followed_user = User.find(params[:followed_id])

    if current_user.following?(@followed_user)
      return respond_to do |format|
        format.html { redirect_to @followed_user, alert: 'You are already following this user.' }
        format.js do
          render template: 'relationships/duplicated_create', status: :bad_request,
                 locals: { user: @followed_user }
        end
      end
    end

    begin
      current_user.follow(@followed_user)
    rescue ActiveRecord::RecordInvalid => e
      return respond_to do |format|
        format.html { redirect_to @followed_user, status: :see_other, notice: e }
        format.js do
          render template: 'relationships/follow_failure', locals: { message: e }, status: :bad_request
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to @followed_user, notice: 'You successfully followed this user.' }
      format.js
    end
  end

  def destroy
    @followed_user = Relationship.find_by(id: params[:id])&.followed

    # case when current_user is not following @followed user
    unless @followed_user
      return respond_to do |format|
        format.html { redirect_to @followed_user, alert: 'You are not following this user.' }
        format.js do
          render template: 'relationships/duplicated_destroy', status: :bad_request
        end
      end
    end

    current_user.unfollow(@followed_user)

    respond_to do |format|
      format.html { redirect_to @followed_user, notice: 'You successfully unfollowed this user.' }
      format.js
    end
  end
end
