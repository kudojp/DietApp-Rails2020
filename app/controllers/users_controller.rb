class UsersController < ApplicationController
  def index
    # TODO: followed userのみ
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end
