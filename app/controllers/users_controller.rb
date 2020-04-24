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
    @user = current_user
  end

  def edit_password
    # TODO
  end

  def update_profile
    @user = current_user
    is_updated = @user.update(user_profile_params)

    return redirect_to profile_edit_path if is_updated

    render 'users/edit_profile'
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

  private

  def user_profile_params
    params.require(:user).permit(:name, :is_male, :height, :weight, :comment)
  end
end
