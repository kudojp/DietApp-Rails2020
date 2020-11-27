class MealPostsController < ApplicationController
  include AjaxHelper
  before_action :authenticate_user!, only: %i[create destroy update]

  def create
    @new_meal_post = current_user.meal_posts.build(new_meal_post_params)

    # meal_post object used for rendering partial form after successfully creating meal_post
    @next_meal_post = current_user.meal_posts.new
    3.times { @next_meal_post&.food_items&.build }

    if @new_meal_post.save
      return respond_to do |format|
        # TODO: friendly forwardingを実装
        format.html { redirect_to root, notice: 'You successfully made a meal post.' }
        format.js
      end
    end

    respond_to do |format|
      # TODO: friendly forwardingを実装
      # TODO: errorを伝搬するなりして、alertをもう少しdescriptiveにする
      format.html { redirect_to root, alert: 'You could not make a meal post.' }
      format.js do
        render 'meal_posts/create_failure', status: :bad_request
      end
    end
  end

  def update
    @meal_post = MealPost.find(params[:id])
    unless @meal_post.user_id == current_user.id
      respond_to do |format|
        format.html { redirect_to root_path, alert: 'You are not authorized to update the post' }
        # (ajaxなど)js-acceptのリクエストでこれが叩かれることは基本ないだろうが、、、
        format.js { render ajax_redirect_to(root_path) }
      end
    end

    is_updated = @meal_post.update(update_meal_post_params)
    # 以下の理由でreloadが必要である
    # (1)counter_cultureで更新される@meal_post.total_caloriesの値をモデルに反映するため
    # (2)@meal_post.food_itemsのそれぞれのmark_for_destructionをfalseに戻すため
    #    ここで設定しないと以下のようなバグが生じる
    #    [バグ]food_itemsを全て消して投稿した後に、画面描写後再び投稿ボタンを押すと「Food items should have at least 1 food item.」というエラーが出る
    @meal_post.reload

    if is_updated
      return respond_to do |format|
        # TODO: friendly forwardingを実装
        format.html { redirect_to root, notice: 'You have successfully updated a meal post.' }
        format.js
      end
    end

    respond_to do |format|
      # TODO: friendly forwardingを実装
      # TODO: errorを伝搬するなりして、alertをもう少しdescriptiveにする
      format.html { redirect_to root, alert: 'You could not update a meal post.' }
      format.js do
        render 'meal_posts/update_failure', status: :bad_request
      end
    end
  end

  def destroy
    @meal_post = MealPost.find(params[:id])
    return redirect_to root_path, alert: 'You are not authorized to delete the post' if @meal_post.user_id == current_user

    @meal_post.destroy
    respond_to do |format|
      # TODO: friendly forwardingを実装
      format.html { redirect_to root }
      format.js
    end
  end

  def show
    @meal_post = MealPost.find(params[:id])
    @is_own_meal_post = @meal_post.user.id == current_user.id
  end

  def upvoted_index
    # meal_posts = User.find(params[:id]).votes.includes(:meal_post).filter(&:is_upvote).map(&:meal_post)
    meal_posts = User.find(params[:id]).favorite_meal_posts.includes(:votes)
    render template: 'meal_posts/index', locals: { title: 'MealPost Upvoted by you', meal_posts: meal_posts }
  end

  def downvoted_index
    meal_posts = User.find(params[:id]).unfavorite_meal_posts.includes(:user)
    render template: 'meal_posts/index', locals: { title: 'MealPost Downvoted by you', meal_posts: meal_posts }
  end

  private

  def new_meal_post_params
    params.require(:meal_post).permit(:content, :time, food_items_attributes: %i[name amount calory _destroy])
  end

  def update_meal_post_params
    # patchメソッドだとRailsアプリケーションでrequest_bodyの配列をうまく解釈できない(hashになる)ため
    params[:meal_post][:food_items_attributes] = params[:meal_post][:food_items_attributes].values
    params.require(:meal_post).permit(:content, :time, food_items_attributes: %i[name amount calory _destroy id])
  end
end
