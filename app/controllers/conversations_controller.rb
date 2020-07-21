class ConversationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @talking_users = current_user.followings
  end

  def show
    @user = User.first
  end
end
