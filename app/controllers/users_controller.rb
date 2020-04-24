class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @title = 'All Users'
  end

  def show
    @user = User.find(params[:id])
    @meal_posts = @user&.meal_posts # &.includes(:user)
  end

  def edit_profile
    # TODO
  end

  def edit_password
    # TODO
  end

  def update_profile
    # TODO
  end

  def update_password
    # TODO
  end

  def destroy_confirmation
    # TODO
  end

  def destroy
    # TODO
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

  def upvoters_index
    @users = MealPost.find(params[:meal_post_id]).upvoters
    @title = 'この頑張りを見てくれてる人達'
    # TODO: viewでどのMealPostに対するvotesかが表示したい
    render 'users/index'
  end

  def downvoters_index
    @users = MealPost.find(params[:meal_post_id]).downvoters
    @title = 'この誘惑に負けた姿を見て嘆いてる人達'
    # TODO: viewでどのMealPostに対するvotesかが表示したい
    render 'users/index'
  end

  def show
    @user = User.find(params[:id])
    @meal_posts = @user&.meal_posts # &.includes(:user)
  end
end
