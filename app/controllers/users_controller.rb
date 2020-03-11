class UsersController < ApplicationController
  def index
    @users = User.all
    @title = 'All Users'
  end

  def followings_index
    @users = User.find(params[:id]).followings
    @title = 'Followings'
    render 'users/index'
  end

  def followers_index
    @users = User.find(params[:id]).followers
    @title = 'Folowers'
    render 'users/index'
  end

  def show
    @user = User.find(params[:id])
  end
end
