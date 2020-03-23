require 'test_helper'

class MealPostsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get meal_posts_url
    assert_response :success
  end

  test 'should get show' do
    get meal_posts_show_url
    assert_response :success
  end

  test 'should get create' do
    get meal_posts_create_url
    assert_response :success
  end

  test 'should get new' do
    get meal_posts_new_url
    assert_response :success
  end

  test 'should get update' do
    get meal_posts_update_url
    assert_response :success
  end
end
