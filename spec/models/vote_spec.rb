require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user1) { create(:user) }
  let(:meal_post1) { create(:meal_post) }
  let(:vote) { build(:vote, user: user1, meal_post: meal_post1) }

  describe 'FactoryBot' do
    it 'returns valid vote' do
      expect(vote).to be_valid
    end
  end

  describe 'validation' do
    it 'is invalid without user' do
      vote.user = nil
      vote.save
      expect(vote.errors[:user]).to include('must exist', "can't be blank")
    end

    it 'is invlaid without meal_post' do
      vote.meal_post = nil
      vote.save
      expect(vote.errors[:meal_post]).to include('must exist', "can't be blank")
    end

    it 'is invlaid without is_upvote' do
      vote.is_upvote = nil
      vote.save
      expect(vote.errors[:is_upvote]).to include('is not included in the list')
    end

    it 'is invalid to follow own post' do
      meal_post1.user = user1
      meal_post1.save
      vote.save
      expect(vote.errors[:meal_post]).to include('cannot vote own meal post')
    end
  end
end
