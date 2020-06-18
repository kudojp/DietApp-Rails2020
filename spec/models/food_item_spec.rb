require 'rails_helper'

RSpec.describe FoodItem, type: :model do
  let(:meal_post) { create(:meal_post) }
  let(:food_item) { create(:food_item, meal_post: meal_post) }

  describe 'FactoryBot' do
    it 'instantiates valid FoodItem model' do
      expect(food_item).to be_valid
    end
  end

  describe 'Validation' do
    it 'is invalid without name' do
      food_item.name = nil
      expect(food_item).not_to be_valid
      expect(food_item.errors[:name].size).to eq 1
      expect(food_item.errors[:name]).to match_array ["can't be blank"]
    end

    it 'requires name composed of 1-30 letters excluding surrounding blank spaces' do
      fi = create(:food_item, meal_post: meal_post)
      fi.name = ' '
      expect(fi).not_to be_valid
      expect(fi.errors.size).to eq 1
      expect(fi.errors[:name]).to match_array ["can't be blank"]

      fi2 = create(:food_item, meal_post: meal_post)
      fi2.name = ' a '
      fi2.save
      # also confirm that it is stripped when saving
      expect(fi2).to be_valid
      expect(fi2.name).to eq 'a'

      fi3 = create(:food_item, meal_post: meal_post)
      fi3.name = 'a' * 30 + ' '
      expect(fi3).to be_valid

      fi3 = create(:food_item, meal_post: meal_post)
      fi3.name = 'a' * 31 + ' '
      expect(fi3).to be_invalid
    end

    it 'is requires amount composed of 1-30 letters excluding surrounding blank spaces' do
      fi = create(:food_item, meal_post: meal_post)
      fi.amount = ' '
      expect(fi).to be_valid

      fi2 = create(:food_item, meal_post: meal_post)
      fi2.amount = ' a '
      fi2.save
      # also confirm that it is stripped when saving
      expect(fi2).to be_valid
      expect(fi2.amount).to eq 'a'

      fi3 = create(:food_item, meal_post: meal_post)
      fi3.amount = 'a' * 30 + ' '
      expect(fi3).to be_valid

      fi3 = create(:food_item, meal_post: meal_post)
      fi3.amount = 'a' * 31 + ' '
      expect(fi3).to be_invalid
    end

    it 'is requires calory composed of positive integer' do
      fi = create(:food_item, meal_post: meal_post)
      fi.calory = 100
      expect(fi).to be_valid

      fi = create(:food_item, meal_post: meal_post)
      fi.calory = nil
      expect(fi).to be_valid

      fi2 = create(:food_item, meal_post: meal_post)
      fi2.calory = 0
      expect(fi2).to be_invalid
      expect(fi2.errors.size).to eq 1
      expect(fi2.errors[:calory]).to match_array ['must be greater than 0']

      fi3 = create(:food_item, meal_post: meal_post)
      fi3.calory = 1.5
      expect(fi3).to be_invalid
      expect(fi3.errors.size).to eq 1
      expect(fi3.errors[:calory]).to match_array ['must be an integer']
    end
  end
end
