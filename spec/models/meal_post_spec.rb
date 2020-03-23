require 'rails_helper'

RSpec.describe MealPost, type: :model do
  let(:meal_post) { create(:meal_post) }
  let(:user) { create(:user) }

  describe 'FactoryBot' do
    it 'instantiates valid meal_post model' do
      m_post = build(:meal_post, user: user)
      expect(m_post).to be_valid
    end
  end

  describe 'Validation' do
    it 'is invalid without user_id' do
      m_post = build(:meal_post, user_id: nil)
      m_post.valid?
      expect(m_post.errors[:user_id]).to include("can't be blank")
    end

    it 'is invalid without time' do
      m_post = build(:meal_post, user: user, time: nil)
      m_post.valid?
      expect(m_post.errors[:time]).to include("can't be blank")
    end

    it 'is invalid without content' do
      m_post = build(:meal_post, user: user, content: nil)
      m_post.valid?
      expect(m_post.errors[:content]).to include("can't be blank")
    end

    it 'validates content to be 1-200 letters excluding surrounding blank spaces' do
      # post composed only of blank spaces is not allowed either
      m_post = build(:meal_post, user: user, content: ' ')
      m_post.valid?
      expect(m_post.errors[:content]).to include("can't be blank")

      m_post = build(:meal_post, user: user, content: 'a')
      expect(m_post).to be_valid

      m_post = build(:meal_post, user: user, content: 'a' * 200)
      expect(m_post).to be_valid
    end
  end

  describe 'List of meal_posts' do
    it 'is in descending order of time' do
      old_post = create(:meal_post, time: '2010/04/14 21:45:22', user: user)
      new_post = create(:meal_post, time: '2014/04/14 21:45:22', user: user)
      mid_post = create(:meal_post, time: '2012/04/14 21:45:22', user: user)

      all_posts = MealPost.all
      expect(all_posts.size).to be(3)
      expect(all_posts[0]).to eq(new_post)
      expect(all_posts[1]).to eq(mid_post)
      expect(all_posts[2]).to eq(old_post)
    end
  end
end
