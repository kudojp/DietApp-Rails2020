require 'rails_helper'

RSpec.describe MealPost, type: :model do
  let(:meal_post) { create(:meal_post) }

  describe 'FactoryBot' do
    it 'instantiates valid meal_post model' do
      expect(meal_post).to be_valid
    end
  end

  describe 'Validation' do
    it 'is invalid without user_id' do
      meal_post = build(:meal_post, user_id: nil)
      meal_post.valid?
      expect(meal_post.errors[:user_id]).to include("can't be blank")
    end

    it 'is invalid without time' do
      meal_post = build(:meal_post, time: nil)
      meal_post.valid?
      expect(meal_post.errors[:time]).to include("can't be blank")
    end

    it 'is invalid without content' do
      meal_post = build(:meal_post, content: '')
      meal_post.valid?
      expect(meal_post.errors[:content]).to include("can't be blank")

      # post composed only of blank spaces is not allowed either
      meal_post = build(:meal_post, content: ' ')
      meal_post.valid?
      expect(meal_post.errors[:content]).to include("can't be blank")
    end
  end
end
