require 'rails_helper'

RSpec.describe MealPost, type: :model do
  let(:meal_post) { create(:meal_post) }
  let(:user) { create(:user) }
  let(:vote) { create(:vote) }

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

  describe '#score' do
    it 'returns the calculated score of votes to this meal_post' do
      Vote.create(user: user, meal_post: meal_post, is_upvote: false)
      expect(meal_post.score).to be(-1)

      Vote.create(user: create(:user), meal_post: meal_post, is_upvote: false)
      expect(meal_post.score).to be(-2)

      Vote.create(user: create(:user), meal_post: meal_post, is_upvote: true)
      expect(meal_post.score).to be(-1)

      Vote.where(user: user, meal_post: meal_post).destroy_all
      expect(meal_post.score).to be(0)
    end
  end

  describe 'has_many :[up|down]voters association' do
    it 'returns (un)favorite meal posts properly' do
      friend1 = create(:user)
      friend2 = create(:user)
      trainer1 = create(:user)
      trainer2 = create(:user)

      upvote1 = Vote.create(user: friend1, meal_post: meal_post, is_upvote: true)
      upvote2 = Vote.create(user: friend2, meal_post: meal_post, is_upvote: true)
      downvote1 = Vote.create(user: trainer1, meal_post: meal_post, is_upvote: false)
      downvote2 = Vote.create(user: trainer2, meal_post: meal_post, is_upvote: false)

      expect(meal_post.upvotes).to match_array([upvote1, upvote2])
      expect(meal_post.upvoters).to match_array([friend1, friend2])

      expect(meal_post.downvotes).to match_array([downvote1, downvote2])
      expect(meal_post.downvoters).to match_array([trainer1, trainer2])
    end
  end
end
